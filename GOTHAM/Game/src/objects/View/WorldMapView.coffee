class WorldMapView extends Gotham.Pattern.MVC.View

  constructor: ->
    super
    that = @

    @__width = 1920
    @__height = 1080 - 70 - 70 # Subtract bar heights

    @__mapSize =
      width: 7200
      height: 3600

  GetCoordFactors: ->
      return {
      latitude: ((@__height / 2) / 90) * -1
      longitude: ((@__width / 2) / 180)
      }

  CoordinateToPixel: (lat, lng) ->
    return {
      x: (lng * @GetCoordFactors().longitude) + (@__width / 2)
      y: (lat * @GetCoordFactors().latitude)  + (@__height / 2)
    }


  create: ->


    """
    Create the background
    """
    @Create_Background()

    """
    Create the world map and node container
    """
    @Create_WorldMap()




  Create_Background: ->



    @_background = background = new Gotham.Graphics.Sprite Gotham.Preload.fetch("sea_background", "image")
    background.width = @__width
    background.height = @__height + 140
    background._size = @size
    background.y = 70
    @addChild background


    # Create mask background
    backgroundMask = new Gotham.Graphics.Graphics
    backgroundMask.beginFill(0x232323, 1)
    backgroundMask.drawRect(0,0,  @__width, @__height)
    backgroundMask.y = 70
    @addChild backgroundMask
    background.mask = backgroundMask


  Create_WorldMap: ->


    that = @

    """
    Create a container for world map
    """
    mapContainer = new Gotham.Graphics.Container
    mapContainer.interactive = true
    mapContainer.hitArea = new Gotham.Graphics.Rectangle 0,0,  @__width, @__height
    @_background.addChild mapContainer

    """
    Activate WheelScrolling on the mapContainer
    """
    GothamGame.renderer.pixi.addWheelScrollObject(mapContainer)

    """
    Activate Panning - Return False and ignore if Longitude < -180 or > 180 and False if Latitude < -90 or > 90
    """
    mapContainer.setPanning (newPosition) ->

      @offset = newPosition

      results =
        x: true
        y: true

      diff =
        x: mapContainer.width - that.__width
        y: mapContainer.height - that.__height

      if diff.x < (newPosition.x * -1) or newPosition.x > 0
        results.x = false

      if diff.y < (newPosition.y * -1) or newPosition.y > 0
        results.y = false

      return results


    """
    MapContainers mouse move:
    * Calculates coordinate in lat,lng
    * Determines country based on lat,lng
    * Sets topBarText
    """
    mapContainer.mousemove =  (e) ->

      #console.log e.stopPropegation()

      pos = e.data.getLocalPosition this
      @_lastMousePosition = pos

      posX = -(that.__width / 2) + pos.x
      posY = -(that.__height / 2) + pos.y

      lat = Math.max(Math.min((posY / that.GetCoordFactors().latitude).toFixed(4), 90), -90)
      long = Math.max(Math.min((posX / that.GetCoordFactors().longitude).toFixed(4), 180), -180)

      # Update currentCoordinates in WorldMap object
      that.currentCoordinates =
        latitude: lat
        longitude: long

      # Calculate which country it belongs to
      country = Gotham.Util.Geocoding.getCountry(lat, long)

      that.parent.getObject("Bar").UpdateCoordinates lat, long
      that.parent.getObject("Bar").UpdateCountry country


    """
    OnWheelScroll
    """
    mapContainer.mouseover = () ->
      @canScroll = true

    mapContainer.mouseout = () ->
      @canScroll = false

    mapContainer.onWheelScroll = (e) ->
      if not @canScroll then return
      direction = e.wheelDeltaY / Math.abs(e.wheelDeltaY)

      # -1 = Wheel out, 1 = Wheen In
      zoomOut = if direction == -1 then true else false

      # Scale Factor per scroll
      factor = 1.1

      prevScale =
        x: @scale.x
        y: @scale.y

      # Calculate what next scaling should be
      nextScale =
        x : if zoomOut then @scale.x / factor else @scale.x * factor
        y : if zoomOut then @scale.y / factor else @scale.y * factor


      # IF: Determine weither we should ignore the scaling
      # ELSE: Scaling should happen, update offsets
      if nextScale.x < 1 or nextScale.y < 1
        @scale =
          x: 1
          y: 1
        return
      else if nextScale.x > 10 or nextScale.y > 10
        @scale =
          x: 10
          y: 10
        return
      else
        @offset.x = if zoomOut then @diff.x / factor else @diff.x * factor
        @offset.y  = if zoomOut then @diff.y / factor else @diff.y * factor

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

      @position.x = (diffSize.width / 2)
      @position.y = (diffSize.height / 2)

      @scale = nextScale


    """
    Create World Map
    """
    worldMap = @_CreateMap()
    mapContainer.addChildArray worldMap


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

  _CreateMap: ->
    # Fetch JSON
    mapJson = Gotham.Preload.fetch("map", "json")

    # Create PolygonList
    polygonList = Gotham.Graphics.Tools.PolygonFromJSON(mapJson, 10, {x: @__mapSize.width / @__width, y: @__mapSize.height / @__height})
    #polygonList2 = Gotham.Graphics.PolygonFromJSON(mapJson, 10)


    # Convert to Graphics objects
    graphicsList = Gotham.Graphics.Tools.PolygonToGraphics(polygonList, true)

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
      graphics.beginFill(0xffffff, 1)
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
        @texture = @hoverTexture

      """
      Mouseout callback
      """
      sprite.mouseout =  (e) ->
        @texture = @normalTexture

      worldMap.push sprite
    return worldMap

  ClearNodeContainer: ->
    for i in @nodeContainer.children
      if i
        i.texture.destroy false
        sprite = @nodeContainer.removeChild i
        sprite = null


  # Adds a nopde to the node container
  #
  # @param node {Object} The Node Data
  AddNode: (node, interact) ->
    # Convert Lat, Lng to Pixel's X and Y
    coordinates = @CoordinateToPixel(node.lat, node.lng)

    # Create a node sprite
    gNode = new Gotham.Graphics.Sprite Gotham.Preload.fetch("map_marker", "image")

    # Set position according to the Lat,Lng conversion
    gNode.position =
      x: coordinates.x
      y: coordinates.y

    # Set Sprites Size
    gNode.width = 8
    gNode.height = 8

    gNode.anchor =
      x: 0.5
      y: 0.5

    # Add a sprite property to the node
    node.sprite = gNode

    # Add to the node container
    @nodeContainer.addChild gNode

    if interact
      @AddNodeInteraction node


  AddNodeInteraction: (node) ->
    that = @

    # The Node should be interactive
    node.sprite.setInteractive true

    # Whenever a node is hovered or exited (mouseover and mouseout)
    nodeHover = (node, tint, visible) ->
      node.sprite.tint = tint

      for _cable in node.Cables

        cable = Gotham.Database.table("cable")({id: _cable.id}).first()
        if not cable then return

        for part in cable.CableParts
          part.visible = visible


    node.sprite.mouseover = ->
      nodeHover node, 0xffff00, true
    node.sprite.mouseout = ->
      nodeHover node, 0xffffff, false


  # Clears animated paths
  ClearAnimatePath: () ->
    # Remove all pathcontainer children # TODO
    if not @pathContainer
      return

    for child in @pathContainer.children
      child.tween.stop()


    @pathContainer.children = []

  # Create a animated attack sequence between two coordinates
  # Parameters are as folloiwng
  # @example Input format
  #     source =
  #         latitude: ""
  #         longitude: ""
  #         country: ""
  #         company: ""
  #     target =
  #         latitude: ""
  #         longitude: ""
  #         country: ""
  #         city: ""
  #         company: ""
  AnimateAttack: (source, target) ->

    # Ignore 0,0 attacks
    if target.country == "O1"
      return

    that = @
    sourcePixel = @CoordinateToPixel source.latitude, source.longitude
    targetPixel = @CoordinateToPixel target.latitude, target.longitude

    #x : path.start.x + (path.end.x - path.start.x) * Math.min(elapsed + 0.2, 1)
    #y : path.start.y + (path.end.y - path.start.y) * Math.min(elapsed + 0.2, 1)



    # Create Lazer
    lazer = new Gotham.Graphics.Graphics();
    lazer.visible = true
    lazer.lineStyle(3, 0xff00ff, 1);
    @nodeContainer.addChild lazer

    #console.log "%s,%s --> %s,%s", sourcePixel.x,sourcePixel.y, targetPixel.x,targetPixel.y

    # Tween lazer
    tween = new Gotham.Tween lazer
    tween.to {}, 3000
    tween.onUpdate (chainItem)->

      # Elapsed tween time
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration

      diff =
        x: (targetPixel.x - sourcePixel.x)
        y: (targetPixel.y - sourcePixel.y)

      distance = Math.sqrt((diff.x**2) + (diff.y**2)) # Distance of the travel a --> b
      length = 20.0 # Line length in pixels

      endModifier = length / distance

      points =
        start:
          x : sourcePixel.x +  diff.x * elapsed
          y : sourcePixel.y +  diff.y * elapsed
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


  # Creates a animated line between two nodes
  #
  # @param startNode {Node} starting node
  # @param endNode {Node} End Node
  AnimatePath: (startNode, endNode) ->
    if not @pathContainer
      @pathContainer = new Gotham.Graphics.Graphics()
      @nodeContainer.addChild @pathContainer

    # Create cable from the network to connected node
    path =
      start: @CoordinateToPixel(startNode.lat, startNode.lng)
      end: @CoordinateToPixel(endNode.lat, endNode.lng)

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

    tween = new Gotham.Tween()
    gCable.tween = tween
    tween.repeat Infinity
    tween.to {}, 2500
    tween.onUpdate (chainItem)->

      # Elapsed tween time
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration

      points =
        start:
          x : path.start.x + (path.end.x - path.start.x) * elapsed
          y : path.start.y + (path.end.y - path.start.y) * elapsed
        end:
          x : path.start.x + (path.end.x - path.start.x) * Math.min(elapsed + 0.2, 1)
          y : path.start.y + (path.end.y - path.start.y) * Math.min(elapsed + 0.2, 1)


      animationGraphics.clear()
      animationGraphics.lineStyle(1, 0x00ff00, 1);
      animationGraphics.moveTo(points.start.x, points.start.y)
      animationGraphics.lineTo(points.end.x, points.end.y)

      # Start from beginning
      if elapsed + 0.2 > 1
        points =
          start:
            x : path.start.x + (path.end.x - path.start.x) * 0
            y : path.start.y + (path.end.y - path.start.y) * 0
          end:
            x : path.start.x + (path.end.x - path.start.x) * Math.min(elapsed + 0.2 - 1, 1)
            y : path.start.y + (path.end.y - path.start.y) * Math.min(elapsed + 0.2 - 1, 1)

        animationGraphics.moveTo(points.start.x, points.start.y)
        animationGraphics.lineTo(points.end.x, points.end.y)


    return tween







  # Adds a cable to given node
  #
  # @param cable {Object} The cable Data
  AddCable: (cable) ->

    # Create a new graphics element
    graphics = new Gotham.Graphics.Graphics();
    graphics.visible = false
    graphics.lineStyle(1, 0xffd900, 1);
    graphics.coordinates = {start:null, end:null}

    cablePartsGraphics = []

    for partData in cable.CableParts
      currentLocation = @CoordinateToPixel(partData.lat, partData.lng)
      if  partData.number is 0
        graphics.coordinates.start = currentLocation
        graphics.moveTo(currentLocation.x, currentLocation.y)
        cablePartsGraphics.push graphics
      else
        graphics.coordinates.end = currentLocation
        graphics.lineTo(currentLocation.x, currentLocation.y);


    # Add graphics cable parts to the cable
    cable.CableParts = cablePartsGraphics

    @nodeContainer.addChild graphics


  # Adds a network to the worldMap
  #
  # @param host [Host] Host object
  # @param lat [Double] Latitude position
  # @param lng [Double Longitude position
  # @param isPlayer [Boolean] If its the player
  AddNetwork: (network,  isPlayer) ->

    # Create a node formatted object
    networkNode =
      lat: network.lat
      lng: network.lng
      sprite: null

    # Add the network to the world map as a node representation
    @AddNode networkNode, false
    networkNode.sprite.width = 32
    networkNode.sprite.height = 32
    networkNode.sprite.tint = 0x00ff00

    return #TODO TODO

    # Create cable from the network to connected node
    cable =
      start: @CoordinateToPixel(network.lat, network.lng)
      end: @CoordinateToPixel(network.Node.lat, network.Node.lng)

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

















module.exports = WorldMapView