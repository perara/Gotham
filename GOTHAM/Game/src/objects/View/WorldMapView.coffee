class WorldMapView extends Gotham.Pattern.MVC.View

  constructor: ->
    super
    that = @

    @__width = 1920
    @__height = 1080 - 70 - 70 # Subtract bar heights

    @__mapSize =
      width: 7200
      height: 3600

  getCoordFactors: ->
      return {
      latitude: ((@__height / 2) / 90) * -1
      longitude: ((@__width / 2) / 180)
      }

  CoordinateToPixel: (lat, lng) ->
    return {
      x: (lng * @getCoordFactors().longitude) + (@__width / 2)
      y: (lat * @getCoordFactors().latitude)  + (@__height / 2)
    }


  create: ->
    """
    Create the background
    """
    @create_background()

    """
    Create the world map and node container
    """
    @create_worldMap()





  create_background: ->
    @_background = background = new Gotham.Graphics.Graphics
    background.lineStyle(2, 0x0000FF, 1)
    background.blendMode = PIXI.blendModes.ADD
    background.drawRect(0,0,  @__width, @__height)
    background.hitArea = new Gotham.Graphics.Rectangle 0,0,  @__width, @__height
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


  create_worldMap: ->
    that = @

    barController = @parent.getObject "Bar"

    """
    Create a container for world map
    """
    mapContainer = new Gotham.Graphics.Sprite
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

      results =
        x: true
        y: true

      # Determine the window size
      origSize =
        x: that.__width
        y: that.__height

      size =
        x: mapContainer.width * that.__width
        y: mapContainer.height * that.__height

      diff =
        x: origSize.x - size.x
        y: origSize.y - size.y

      if diff.x > newPosition.x or newPosition.x > 0
        results.x = false

      if diff.y > newPosition.y or newPosition.y > 0
        results.y = false

      return results



    """
    MapContainers mouse move:
    * Calculates coordinate in lat,lng
    * Determines country based on lat,lng
    * Sets topBarText
    """
    mapContainer.mousemove =  (e) ->

      interactionManager = new PIXI.InteractionManager()

      if(interactionManager.hitTest(that._background, e))
        pos = e.getLocalPosition this
        @_lastMousePosition = pos

        posX = -(that.__width / 2) + pos.x
        posY = -(that.__height / 2) + pos.y

        lat = Math.max(Math.min((posY / that.getCoordFactors().latitude).toFixed(4), 90), -90)
        long = Math.max(Math.min((posX / that.getCoordFactors().longitude).toFixed(4), 180), -180)

        # Update currentCoordinates in WorldMap object
        that.currentCoordinates =
          latitude: lat
          longitude: long

        # Calculate which country it belongs to
        country = Gotham.Util.Geocoding.getCountry(lat, long)

        barController.updateCoordinates lat, long
        barController.updateCountry country


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
        @offset.x = if zoomOut then @offset.x /= factor else @offset.x *= factor
        @offset.y = if zoomOut then @offset.y /= factor else @offset.y *= factor


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

      # Set position in center # TODO
      @position.x = (diffSize.width / 2)  + @offset.x
      @position.y = (diffSize.height / 2) + @offset.y

      # Update the scaling
      @scale = nextScale



    """
    Create World Map
    """
    worldMap = @_createMap()
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

  _createMap: ->
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
      graphics.lineStyle(3, 0xFF0000, 1);
      graphics.blendMode = PIXI.blendModes.ADD
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
        #@bringToFront()
        @texture = @hoverTexture

      """
      Mouseout callback
      """
      sprite.mouseout =  (e) ->
        @texture = @normalTexture

      worldMap.push sprite
    return worldMap

  clearNodeContainer: ->
    for i in @nodeContainer.children
      if i
        i.texture.destroy false
        sprite = @nodeContainer.removeChild i
        sprite = null


  # Adds a nopde to the node container
  #
  # @param node {Object} The Node Data
  addNode: (node, interact) ->
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
      @addNodeInteract node


  addNodeInteract: (node) ->
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



  # Creates a animated line between two nodes
  #
  # @param startNode {Node} starting node
  # @param endNode {Node} End Node
  animatePath: (startNode, endNode) ->




  # Adds a cable to given node
  #
  # @param cable {Object} The cable Data
  addCable: (cable) ->

    # Create a new graphics element
    graphics = new Gotham.Graphics.Graphics();
    graphics.visible = false
    graphics.lineStyle(1, 0xffd900, 1);

    cablePartsGraphics = []


    for partData in cable.CableParts
      currentLocation = @CoordinateToPixel(partData.lat, partData.lng)

      if  partData.number is 0
        cablePartsGraphics.push graphics
        graphics.moveTo(currentLocation.x, currentLocation.y)
      else
        graphics.lineTo(currentLocation.x, currentLocation.y);

    # Add graphics cable parts to the cable
    cable.CableParts = cablePartsGraphics

    @nodeContainer.addChild graphics


  # Adds a host to the worldMap
  #
  # @param host [Host] Host object
  # @param isPlayer [Boolean] If its the player
  addHost: (host, isPlayer) ->

    node =
      lat: host.person.lat
      lng: host.person.lng
      sprite: null

    # Add node to map, and customize size and color
    @addNode node, false
    node.sprite.width = 32
    node.sprite.height = 32
    node.sprite.tint = 0x00ff00


    # Create cable from HOST --> NODE
    cableStart = @CoordinateToPixel(node.lat, node.lng)
    cableEnd = @CoordinateToPixel(host.node.lat, host.node.lng)

    cableGraphics = new Gotham.Graphics.Graphics();
    cableGraphics.visible = true
    cableGraphics.lineStyle(5, 0xff0000, 1);
    cableGraphics.moveTo(cableStart.x, cableStart.y)
    cableGraphics.lineTo(cableEnd.x, cableEnd.y)
    @nodeContainer.addChild cableGraphics


    animationGraphics = new Gotham.Graphics.Graphics();
    animationGraphics.visible = true
    animationGraphics.blendMode = PIXI.blendModes.ADD;
    @nodeContainer.addChild animationGraphics

    tween = new Gotham.Tween()
    tween.repeat Infinity
    tween.to {}, 1500
    tween.onUpdate (chainItem)->
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration

      points =
        start:
          x : cableStart.x + (cableEnd.x - cableStart.x) * elapsed
          y : cableStart.y + (cableEnd.y - cableStart.y) * elapsed
        end:
          x : cableStart.x + (cableEnd.x - cableStart.x) * Math.min(elapsed + 0.2, 1)
          y : cableStart.y + (cableEnd.y - cableStart.y) * Math.min(elapsed + 0.2, 1)
      animationGraphics.clear()
      animationGraphics.lineStyle(2, 0x00ff00, 1);
      animationGraphics.moveTo(points.start.x, points.start.y)
      animationGraphics.lineTo(points.end.x, points.end.y)


    tween.start()
















module.exports = WorldMapView