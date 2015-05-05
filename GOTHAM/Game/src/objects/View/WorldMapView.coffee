

###*
# WorldMapView is the view part of the world map. Map creation, node, calbe and animations are done here. see method docs
# @class WorldMapView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class WorldMapView extends Gotham.Pattern.MVC.View
  constructor: ->
    super


    ###*
    # Width of the world map
    # @property {Number} __width
    ###
    @__width = 1920

    ###*
    # Height of the world map
    # @property {Number} __height
    ###
    @__height = 1080 # Subtract bar heights

    ###*
    # Initial / Original map size
    # @property {Object} __mapSize
    ###
    @__mapSize =
      width: 7200
      height: 3600


  ###*
  # Get the coorinate factors for latitude and longitude based on the maps current size and scale
  # @method getCoordFactors
  # @return {Object}the latitude and longitude property inside a object
  ###
  getCoordFactors: ->
    return {
    latitude: ((@__height / 2) / 90) * -1
    longitude: ((@__width / 2) / 180)
    }


  ###*
  # Converts a lat,lng coordinate to a pixel coordinate (x,y)
  #
  # @method coordinateToPixel
  # @param lat {Number} The latitude
  # @param lng {Number} The longitude
  # @returns {Object} The X and Y coordinate inside a object
  ###
  coordinateToPixel: (lat, lng) ->
    return {
    x: (lng * @getCoordFactors().longitude) + (@__width / 2)
    y: (lat * @getCoordFactors().latitude)  + (@__height / 2)
    }


  ###*
  # Creates everything
  #
  # @method create
  ###
  create: ->

    """
    Create the background
    """
    @createBackground()

    """
    Create the world map and node container
    """
    @createWorldMap()




  ###*
  # Creates the background object
  #
  # @method createBackground
  ###
  createBackground: ->
    @_background = background = new Gotham.Graphics.Sprite Gotham.Preload.fetch("sea_background", "image")
    background.width = @__width
    background.height = @__height + 140
    background._size = @size
    background.y = 0
    @addChild background


  ###*
  # Scale the node to reflect WorldMap's scale
  #
  # @method scaleNodes
  ###
  scaleNodes: () ->
    that = @

    # Fetch node table
    db_node = Gotham.Database.table "node"

    # Scale each of the nodes
    for row in db_node.find()
      node = row.sprite

      node.scale.x = (Math.max(0.08, (that.mapContainer.scale.x * 4)**-1))
      node.scale.y = (Math.max(0.08, (that.mapContainer.scale.y * 4)**-1))


  ###*
  # Creates the WorldMap container with the worldMap function.
  # Adds this sprite array to the container and creates the map.
  #
  # @method createWorldMap
  ###
  createWorldMap: ->
    that = @

    """
    Create a container for world map
    """
    @mapContainer = mapContainer = new Gotham.Graphics.Container
    mapContainer.interactive = true
    mapContainer.scale =
      x: 0.8
      y: 0.8
    mapContainer.x = (@__width - (@__width * mapContainer.scale.x)) / 2


    mapContainer.hitArea = new Gotham.Graphics.Rectangle 0,0,  @__width, @__height
    @_background.addChild mapContainer

    """
    Activate WheelScrolling on the mapContainer
    """
    GothamGame.Renderer.pixi.addWheelScrollObject(mapContainer)


    """
    Activate Panning - Return False and ignore if Longitude < -180 or > 180 and False if Latitude < -90 or > 90
    """
    mapContainer.setPanning (newPosition) ->
      # Hide Node Details
      that.hideNodeDetails()

      @offset = newPosition

      return {x: true, y: true}


    mapContainer.offset =
      y: -70
      x: 0


    """
    MapContainers mouse move:
    * Calculates coordinate in lat,lng
    * Determines country based on lat,lng
    * Sets topBarText
    """
    mapContainer.onMouseMove =  (e) ->

      pos = e.data.getLocalPosition this
      @_lastMousePosition = pos

      posX = -(that.__width / 2) + pos.x
      posY = -(that.__height / 2) + pos.y

      lat = Math.max(Math.min((posY / that.getCoordFactors().latitude).toFixed(4), 90), -90)
      long = Math.max(Math.min((posX / that.getCoordFactors().longitude).toFixed(4), 180), -180)

      # Update currentCoordinates in WorldMap object
      that.currentCoordinates =
        latitude: lat
        longitude: long

      that.parent.getObject("Bar").updateCoordinates lat, long

    mapContainer.click = () ->

      # If GothShark is visible and the map is clicked. Tween back to original map position
      if $("#node-details").is(":visible")

        # Check if user is hovering ANY of the terminal frames
        isHovering = false
        $('.terminal_frame').each (index) ->
          check = $(@).is(":hover")
          if check
            isHovering = true
            return

        # Hide and zoom back if not hovering
        if not isHovering
          that.hideNodeDetails()

          # Zooms the map back to original size
          that.zoomMap(0.8, 400)


    """
    OnWheelScroll
    """
    mapContainer.mouseover = () ->
      @canScroll = true
      console.log "Setting true"

    mapContainer.mouseout = () ->
      @canScroll = false
      @isDragging = false
      console.log "Setting false"

    mapContainer.onWheelScroll = (e) ->
      if not @canScroll then return
      direction = e.wheelDeltaY / Math.abs(e.wheelDeltaY)

      # -1 = Wheel out, 1 = Wheen In
      @isZoomOut = zoomOut = if direction == -1 then true else false

      # Scale Factor per scroll
      factor = 1.1

      prevScale =
        x: @scale.x
        y: @scale.y

      # Calculate what next scaling should be
      nextScale =
        x: @scale.x * (factor**direction)
        y: @scale.y * (factor**direction)

      # IF: Determine weither we should ignore the scaling
      # ELSE: Scaling should happen, update offsets
      if nextScale.x < 0.4 or nextScale.y < 0.4
        return
      else if nextScale.x > 10 or nextScale.y > 10
        return
      else
        # Hide Node Details
        that.hideNodeDetails()

        @scale = nextScale
        # Scale Nodes
        that.scaleNodes(zoomOut)

      @offset.x = @offset.x * (factor**direction)
      @offset.y = @offset.y * (factor**direction)

      # Calculate the size offset, we do this to move
      prevSize =
        width : that.__width
        height : that.__height

      nextSize =
        width : that.__width * nextScale.x
        height : that.__height * nextScale.y

      diffSize =
        width: prevSize.width - nextSize.width
        height: prevSize.height - nextSize.height


      @position.x = (diffSize.width / 2) + @offset.x
      @position.y = (diffSize.height / 2) + @offset.y




    """
    Create World Map
    """
    worldMap = @createMap()

    for mapItem in worldMap
      if mapItem.width < 10 or mapItem.height < 10
        continue
      mapContainer.addChild mapItem


    """count = 0
    setInterval (() ->

      mapContainer.addChild worldMap[count++]
      console.log worldMap[count].width, worldMap[count].height
    ), 50"""


    #mapContainer.addChildArray worldMap


    """
    Create a container for all nodes
    """
    @nodeContainer = nodeContainer = new Gotham.Graphics.Graphics
    mapContainer.addChild nodeContainer


    """
    Determine Center of the map and create a red dot
    """
    middle = new Gotham.Graphics.Graphics()
    middle.lineStyle(0);
    middle.beginFill(0xff0000, 1);
    middle.drawCircle(@__width / 2, @__height / 2, 1);
    mapContainer.addChild middle
    return mapContainer

  ###*
  # Creates the World map from json,
  # @method createMap
  # @return {Gotham.Graphics.Sprite[]} Array of all the country polygons
  ###
  createMap: ->
    that = @

    # Fetch JSON
    mapJson = Gotham.Preload.fetch("map", "json")

    # Create PolygonList
    polygonList = Gotham.Graphics.Tools.polygonFromJSON mapJson, 1 , {x: @__mapSize.width / @__width, y: @__mapSize.height / @__height}
    #polygonList = Gotham.Graphics.Tools.polygonFromJSON(mapJson, 1)


    # Convert to Graphics objects
    graphicsList = Gotham.Graphics.Tools.polygonToGraphics(polygonList, true)

    # Add Each of the graphic objects to the world map
    worldMap = []
    for graphics, key in graphicsList


      """
      Generate country texture
      """
      texture = graphics.generateTexture()

      """
      Generate country texture, with hover effect
      """
      graphics.clear()
      graphics.lineStyle(2, 0x000000, 1);
      graphics.beginFill(0xffffff, 0.8)
      graphics.blendMode = PIXI.BLEND_MODES.ADD
      graphics.drawPolygon(graphics.polygon.points)
      hoverTexture = graphics.generateTexture()

      """
      Create a country sprite, Using generated textures
      """
      sprite = new Gotham.Graphics.Sprite texture
      sprite.hoverTexture = hoverTexture

      sprite.position.x = graphics.minX
      sprite.position.y = graphics.minY

      """
      Translate sprite position correctly.
      Use polygon points to determine the position
      """
      translatedPoints = []
      xory = 0
      for point in graphics.polygon.points
        if xory++ % 2 == 0
          translatedPoints.push(point - sprite.x)
        else
          translatedPoints.push(point - sprite.y)


      """
      Create a hitarea of the translated points
      Activate interaction
      """
      hitarea = new PIXI.Polygon translatedPoints
      sprite.hitArea = hitarea
      sprite.setInteractive true

      """
      Mouseover callback
      """
      sprite.mouseover =  (e) ->
        # Calculate which country it belongs to
        setTimeout((->
          country = Gotham.Util.Geocoding.getCountry(that.currentCoordinates.latitude, that.currentCoordinates.longitude)
          that.parent.getObject("Bar").updateCountry country
        ), 20)

        @texture = @hoverTexture

      """
      Mouseout callback
      """
      sprite.mouseout =  (e) ->
        that.parent.getObject("Bar").updateCountry null
        @texture = @normalTexture

      worldMap.push sprite
    return worldMap


  ###*
  # Deletes all nodes in the node container
  # @method clearNodeContainer
  ###
  clearNodeContainer: ->
    for i in @nodeContainer.children
      if i
        i.texture.destroy false
        sprite = @nodeContainer.removeChild i
        sprite = null



  ###*
  # Adds a nopde to the node container
  # @method addNode
  # @param node {Object} The Node ObjECT
  # @param interact {Boolean} Weither the node should be interactive or not
  ###
  addNode: (node, interact) ->
    # Convert Lat, Lng to Pixel's X and Y
    coordinates = @coordinateToPixel(node.lat, node.lng)

    # Create a node sprite
    gNode = new Gotham.Graphics.Sprite Gotham.Preload.fetch("map_marker", "image")
    gNode.tint = 0xF8E23B

    gNode.infoFrame = @nodeInfoFrame(node)
    gNode.addChild gNode.infoFrame

    # Set position according to the Lat,Lng conversion
    gNode.position =
      x: coordinates.x
      y: coordinates.y

    # Add original scale variable
    gNode.originalScale =
      x: gNode.scale.x
      y: gNode.scale.y

    # Set Sprites Size
    gNode.width = 8
    gNode.height = 8

    gNode.anchor =
      x: 0.4
      y: 0.4

    # Add a sprite property to the node
    node.sprite = gNode

    # Add to the node container
    @nodeContainer.addChild gNode

    if interact
      @addNodeInteraction node

  ###*
  # Adds interaction to a node, Typically hovering it showing cables.
  # @method addNodeInteraction
  # @param node {Node}
  ###
  addNodeInteraction: (node) ->
    that = @

    # The Node should be interactive
    node.sprite.interactive = true

    # Whenever a node is hovered or exited (mouseover and mouseout)
    nodeHover = (node, tint, visible) ->

      # Update country information
      that.parent.getObject("Bar").updateCountry node.Country

      node.sprite.tint = tint

      for _cable in node.Cables

        cable = Gotham.Database.table("cable").findOne({id: _cable.id})
        if not cable then return

        for part in cable.CableParts
          part.visible = visible

    node.sprite.click = ->
      @_toggle = if not @_toggle then true else !@_toggle

      if @_toggle
        @infoFrame.visible = true
        @bringToFront()
      else
        @infoFrame.visible = false


    node.sprite.mouseover = ->
      nodeHover node, 0xFF0000, true


    node.sprite.mouseout = ->
      nodeHover node, 0xF8E23B, false

  ###*
  # Shows the node-details selector in HTML (GothShark)
  # @method showNodeDetails
  ###
  showNodeDetails: (node) ->
    window.GothShark.updateNode(node)
    $("#node-details").fadeIn()

  ###*
  # Hides the node-details selector in HTML (GothShark)
  # @method hideNodeDetails
  ###
  hideNodeDetails: () ->
    $("#node-details").fadeOut()

  ###*
  # Creates the information plate of each of the node,
  # @method nodeInfoFrame
  # @param node {Gotham.Graphics.Sprite} The node object
  # @return {Gotham.Graphics.Sprite} The newly created sprite (Info Frame)
  ###
  nodeInfoFrame: (node) ->
    that = @

    infoFrame = new Gotham.Graphics.Sprite Gotham.Preload.fetch("node_details", "image")
    infoFrame.visible = false
    infoFrame.interactive = true

    wireShark = new Gotham.Controls.Button "Sniff", 450, 200, {textSize: 70}
    wireShark.x = 80
    wireShark.y = 40
    infoFrame.addChild wireShark


    infoFrame.click = ->
      @ready = if not @ready then true else @ready


      if @ready
        infoFrame.visible = false
        @ready = false

        that.mapContainer.interactive = false
        that.mapContainer.isDragging = false

        # Zooms out the map to make room for GothOS
        tween = that.zoomMap(0.4, 400)
        tween.onComplete (tweenObj) ->

          that.mapContainer.offset = {y: -305, x: 0}

          # Set interactive and Y pos
          that.mapContainer.interactive = true

          # Show node detail
          that.showNodeDetails(node)

          @ready = true

    return infoFrame




  ###*
  # Clears the pathContainer, This is typically Traceroutes
  # @method clearAnimatePath
  ####
  clearAnimatePath: () ->
    # Remove all pathcontainer children # TODO
    if not @pathContainer
      return

    for child in @pathContainer.children
      child.tween.stop()


    @pathContainer.children = []

  ###*
  # Create a animated attack sequence between two coordinates
  # Parameters are as folloiwng
  # @method animateAttack
  # @param source {Object} Source Data
  # @param target {Object} Target Data
  # @example Input format
  #   source =
  #     latitude: ""
  #     longitude: ""
  #     country: ""
  #     company: ""
  #   target =
  #     latitude: ""
  #     longitude: ""
  #     country: ""
  #     city: ""
  #     company: ""
  ###
  animateAttack: (source, target) ->

    # Ignore 0,0 attacks
    if target.country == "O1"
      return

    that = @
    sourcePixel = @coordinateToPixel source.latitude, source.longitude
    targetPixel = @coordinateToPixel target.latitude, target.longitude

    #x : path.start.x + (path.end.x - path.start.x) * Math.min(elapsed + 0.2, 1)
    #y : path.start.y + (path.end.y - path.start.y) * Math.min(elapsed + 0.2, 1)



    # Create Lazer
    lazer = new Gotham.Graphics.Graphics();
    lazer.visible = true
    lazer.lineStyle(3, 0xff00ff, 1);
    @nodeContainer.addChild lazer

    #console.log "%s,%s --> %s,%s", sourcePixel.x,sourcePixel.y, targetPixel.x,targetPixel.y

    diff =
      x: (targetPixel.x - sourcePixel.x)
      y: (targetPixel.y - sourcePixel.y)

    distance = Math.sqrt((diff.x**2) + (diff.y**2)) # Distance of the travel a --> b
    length = 20.0 # Line length in pixels
    endModifier = length / distance

    t = distance / 0.4

    # Tween lazer
    tween = new Gotham.Tween lazer
    tween.to {}, t
    tween.onUpdate (chainItem)->
      # Elapsed tween time
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration

      points =
        start:
          x : sourcePixel.x +  diff.x * Math.max(elapsed,0)
          y : sourcePixel.y +  diff.y * Math.max(elapsed,0)
        end:
          x : sourcePixel.x + diff.x * Math.min(elapsed + endModifier, 1)
          y : sourcePixel.y + diff.y * Math.min(elapsed + endModifier, 1)


      lazer.clear()
      lazer.lineStyle(3, 0xff00ff, 1);
      lazer.moveTo(points.start.x, points.start.y)
      lazer.lineTo(points.end.x, points.end.y)


    tween.onComplete () ->
      that.nodeContainer.removeChild lazer
    tween.start()


  ###*
  # Creates a animated line between two nodes
  #
  # @method animatePath
  # @param startNode {Node} starting node
  # @param endNode {Node} End Node
  # @return {Tween} The tween object for the animation
  ###
  animatePath: (startNode, endNode) ->
    if not @pathContainer
      @pathContainer = new Gotham.Graphics.Graphics()
      @nodeContainer.addChild @pathContainer


    # Create cable from the network to connected node
    path =
      start: @coordinateToPixel(startNode.lat, startNode.lng)
      end: @coordinateToPixel(endNode.lat, endNode.lng)



    # Create graphics object for cable
    gCable = new Gotham.Graphics.Graphics();
    gCable.visible = true
    gCable.lineStyle(3, 0xff00ff, 1);
    gCable.moveTo(path.start.x, path.start.y)
    gCable.lineTo(path.end.x, path.end.y)
    @pathContainer.addChild gCable

    # Create graphics for animated object (Yellow line which moves inside graphics)
    animationGraphics = new Gotham.Graphics.Graphics();
    animationGraphics.visible = true
    animationGraphics.blendMode = PIXI.BLEND_MODES.ADD;
    gCable.addChild animationGraphics

    diff =
      x: (path.end.x - path.start.x)
      y: (path.end.y - path.start.y)

    tween = new Gotham.Tween()
    gCable.tween = tween
    tween.repeat Infinity
    tween.to {}, 1500
    tween.onUpdate (chainItem)->


      # Elapsed tween time
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration


      points =
        start:
          x : path.start.x + diff.x * Math.max(elapsed - 0, 0)
          y : path.start.y + diff.y * Math.max(elapsed - 0, 0)
        end:
          x : path.start.x + diff.x * Math.min(elapsed + 0.1, 1)
          y : path.start.y + diff.y * Math.min(elapsed + 0.1, 1)

      # Start drawing
      animationGraphics.clear()
      animationGraphics.lineStyle(1, 0x00ff00, 1);
      animationGraphics.moveTo(points.start.x, points.start.y)
      animationGraphics.lineTo(points.end.x, points.end.y)


    return tween


  ###*
  # Adds a cable and draws it between two nodes (Sibling)
  # @method addCable
  # @param cable {Object}
  ###
  addCable: (cable) ->

    # Create a new graphics element
    graphics = new Gotham.Graphics.Graphics();
    graphics.visible = false
    graphics.lineStyle(1, 0xffd900, 1);
    graphics.coordinates = {start:null, end:null}

    cablePartsGraphics = []

    for partData in cable.CableParts
      currentLocation = @coordinateToPixel(partData.lat, partData.lng)

      if partData.number is 0
        graphics.coordinates.start = currentLocation
        graphics.moveTo(currentLocation.x, currentLocation.y)
        cablePartsGraphics.push graphics
      else
        graphics.coordinates.end = currentLocation
        graphics.lineTo(currentLocation.x, currentLocation.y)


    # Add graphics cable parts to the cable
    cable.CableParts = cablePartsGraphics

    @nodeContainer.addChild graphics


  ###*
  # Adds a network to the worldMap
  # @method addNetwork
  # @param host [Host] Host object
  # @param lat [Double] Latitude position
  # @param lng [Double Longitude position
  # @param isPlayer [Boolean] If its the player
  ###
  addNetwork: (network,  isPlayer) ->

    # Create a node formatted object
    networkNode =
      lat: network.lat
      lng: network.lng
      sprite: null

    # Add the network to the world map as a node representation
    @addNode networkNode, false
    networkNode.sprite.width = 32
    networkNode.sprite.height = 32
    networkNode.sprite.tint = 0x00ff00

    return #TODO TODO

    # Create cable from the network to connected node
    cable =
      start: @coordinateToPixel(network.lat, network.lng)
      end: @coordinateToPixel(network.Node.lat, network.Node.lng)

    # Create graphics object for cable
    gCable = new Gotham.Graphics.Graphics();
    gCable.visible = true
    gCable.lineStyle(5, 0xff0000, 1);
    gCable.moveTo(cable.start.x, cable.start.y)
    gCable.lineTo(cable.end.x, cable.end.y)
    @nodeContainer.addChild gCable

    # Create graphics for animated object (Yellow line which moves inside graphics)
    animationGraphics = new Gotham.Graphics.Graphics();
    animationGraphics.visible = true
    animationGraphics.blendMode = PIXI.BLEND_MODES.ADD;
    gCable.addChild animationGraphics

    tween = new Gotham.Tween()
    tween.repeat Infinity
    tween.to {}, 2500
    tween.onUpdate (chainItem)->

      # Elapsed tween time
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration

      points =
        start:
          x : cable.start.x + (cable.end.x - cable.start.x) * elapsed
          y : cable.start.y + (cable.end.y - cable.start.y) * elapsed
        end:
          x : cable.start.x + (cable.end.x - cable.start.x) * Math.min(elapsed + 0.2, 1)
          y : cable.start.y + (cable.end.y - cable.start.y) * Math.min(elapsed + 0.2, 1)

      animationGraphics.clear()
      animationGraphics.lineStyle(2, 0x00ff00, 1);
      animationGraphics.moveTo(points.start.x, points.start.y)
      animationGraphics.lineTo(points.end.x, points.end.y)

      # Start from beginning
      if elapsed + 0.2 > 1
        points =
          start:
            x : cable.start.x + (cable.end.x - cable.start.x) * 0
            y : cable.start.y + (cable.end.y - cable.start.y) * 0
          end:
            x : cable.start.x + (cable.end.x - cable.start.x) * Math.min(elapsed + 0.2 - 1, 1)
            y : cable.start.y + (cable.end.y - cable.start.y) * Math.min(elapsed + 0.2 - 1, 1)

        animationGraphics.moveTo(points.start.x, points.start.y)
        animationGraphics.lineTo(points.end.x, points.end.y)

    tween.start()

  ###*
  # Zooms the map to a given Scale, The map is Centered around Width/2 and Height /2
  # The animation is done by tweening
  # @method zoomMap
  # @param scale {Number} The scale number, Usually, never above 1.5
  # @param duration=2000 {Number} The Animation duration
  ###
  zoomMap: (scale, duration = 400) ->
    that = @

    # Capture original scale of the mapContainer
    originalScale =
      x: that.mapContainer.scale.x
      y: that.mapContainer.scale.y

    # Create tween object
    tween = new Gotham.Tween that.mapContainer
    tween.easing Gotham.Tween.Easing.Quadratic.In
    tween.to {
      position:
        y: 1
        x: (that.__width / 2) - (that.__width * scale)/2
    }, duration
    tween.start()
    tween.onUpdate (tweenChain) ->
      elapsed = tweenChain.elapsed

      # Scale Stuff
      diffScale =
        x: (scale - originalScale.x) * elapsed
        y: (scale - originalScale.y) * elapsed

      nexScale =
        x: originalScale.x - (diffScale.x * -1)
        y: originalScale.y - (diffScale.y * -1)


      factor =
        x: (that.__width * nexScale.x) / (that.__width * that.mapContainer.scale.x)
        y: (that.__height * nexScale.y) / (that.__height * that.mapContainer.scale.y)

      # Size stuff
      prevSize =
        width : that.__width
        height : that.__height

      nextSize =
        width : that.__width * nexScale.x
        height : that.__height * nexScale.y

      diffSize =
        width: prevSize.width - nextSize.width
        height: prevSize.height - nextSize.height


      that.mapContainer.scale.x = nexScale.x
      that.mapContainer.scale.y = nexScale.y

      that.mapContainer.offset.x *= factor.x
      that.mapContainer.offset.y *= factor.y


      that.mapContainer.position.x = (diffSize.width / 2) + that.mapContainer.offset.x
      that.mapContainer.position.y = (diffSize.height / 2) +  that.mapContainer.offset.y

      that.scaleNodes true
    return tween






module.exports = WorldMapView