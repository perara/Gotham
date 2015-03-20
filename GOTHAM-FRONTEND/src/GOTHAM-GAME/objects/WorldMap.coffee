

class WorldMap extends Gotham.Graphics.Container

  constructor: ->
    super
    that = @
    @name = "WorldMap"
    @setNetworkHub("worldMap")

    # The original map scale (The scale the map starts out with)
    @originalMapScale =
      x: 3.84
      y: 3.06

    # The original map size (The size on init, no scaling)
    @originalSize =
      width: 7200
      height: 3600

    # The size of the map after the original scaling is acounted for
    @originalScaledSize =
      width: @originalSize.width / @originalMapScale.x
      height: @originalSize.height / @originalMapScale.y

    # Current Size of the Map
    @size = @originalScaledSize

    # This callback returns a array with nodes from the server. These nodes should be processed by the WorldMap
    # A function which places these nodes must be used.
    @addNetworkMethod "fetchMap", (json) ->

      # Parse data as JSON
      data = JSON.parse json

      # Insert the nodes into the "node" table
      db_node = GothamGame.Database.table("node")
      db_node.insert data.nodes

      # Insert cables into the "cables" table
      db_cable = GothamGame.Database.table("cable")
      db_cable.insert data.cables

      # Fire World Scene's "onNodesLoaded" callback
      that.parent.Callbacks.onNodesLoaded()

      # Iterate Through the Node Table
      db_node().each (row) ->
        that.addNode row

      # Iterate Through the Cable Table
      db_cable().each (row) ->
        that.addCable row


    # Runs when the SignalR client is connected to the server
    @network.onConnect =  (connection) ->
      connection.server.send("Test", "Fest")
      connection.server.requestMap()

  getCoordFactors: ->
    coordFactors =
      latitude: ((@originalScaledSize.height / 2) / 90) * -1
      longitude: ((@originalScaledSize.width / 2) / 180)
    return coordFactors

  pixelToCoordinate: (x, y) ->
    posX = -(@size.width / 2) + x
    posY = -(@size.height / 2) + y

    coordinates =
      latitude: Math.max(Math.min((posY / @getCoordFactors().latitude).toFixed(4), 90), -90)
      longitude: Math.max(Math.min((posX / @getCoordFactors().longitude).toFixed(4), 180), -180)
    return coordinates


  getMapCoordinates: ->
    # Coordinate Definitions
    mapCoordinates =
      origo:
        x: (@size.width / 2) / @originalMapScale.x
        y: (@size.height / 2) / @originalMapScale.y
      north: # 90
        x: (@size.width / 2) / @originalMapScale.x
        y: 0
      south: # -90
        x: (@size.width / 2) / @originalMapScale.x
        y: @size.height / @originalMapScale.y
      west: # -180 Long
        x: 0
        y: (@size.height / 2) / @originalMapScale.y
      east: # 180 Long
        x: @size.width / @originalMapScale.x
        y: (@size.height / 2) / @originalMapScale.y
    return mapCoordinates

  CoordinateToPixel: (lat, lng) ->
    ret =
    x: (lng * @getCoordFactors().longitude) + (@size.width / 2)
    y: (lat * @getCoordFactors().latitude)  + (@size.height / 2)
    return ret

  addNode: (node) ->

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

    # The Node should be interactive
    gNode.setInteractive true

    # Add to the node container
    @nodeContainer.addChild gNode

    # Add an array definition which should contain cables for this node @see addCable(cable)
    node.cables = gNode.cables = []

    # Add a sprite property to the node
    node.sprite = gNode


    gNode.mouseover = ->
      @tint = 0xffff00
      for cable in @cables
        for part in cable.cableParts
          part.visible = true

    gNode.mouseout = ->
      @tint = 0xffffff
      for cable in @cables
        for part in cable.cableParts
          part.visible = false




  addCable: (cable) ->

    # Add Cable to each of the node id's

    for nodeId in cable.nodeids

      # Fetch the node
      node = GothamGame.Database.table("node")({id: nodeId}).first()

      # Push cable to the node
      node.cables.push cable


    # Determine first graphics location and move the pointer
    firstLocation = @CoordinateToPixel(cable.cableParts[0].lat, cable.cableParts[0].lng)

    # Create a new graphics element
    graphics = new Gotham.Graphics.Graphics();
    graphics.visible = false
    graphics.lineStyle(1, 0xffd900, 1);

    previousLocation =
      x: -9000000
      y: -9000000

    isStart = true


    testX = @size.width / 2
    testY = @size.height  / 2

    for i in [0...cable.cableParts.length]
      partData = cable.cableParts[i]
      currentLocation = @CoordinateToPixel(partData.lat, partData.lng)

      if isStart or partData.number is 0
        cable.cableParts[i] = graphics
        graphics.moveTo(currentLocation.x, currentLocation.y)
        isStart = false
      else
        graphics.lineTo(currentLocation.x, currentLocation.y);
        previousLocation = currentLocation
        cable.cableParts[i] = undefined

    # Strip undefined values
    cable.cableParts = cable.cableParts.filter (n) ->
      return n if not undefined

    @nodeContainer.addChild graphics


  ###
  This function scales the nodes according to the WorldMap Scaling
  ###
  scaleNodes: (zoomOut) ->

    # Determine weither its zoom in or zoom out
    inorout = if zoomOut then 1 else -1

    # Fetch node table
    db_node = GothamGame.Database.table "node"

    # Scale each of the nodes
    db_node().each (row) ->
      node = row.sprite
      if zoomOut
        node.scale.x = (node.scale.x * 1.05)
        node.scale.y = (node.scale.y * 1.05)
      else
        node.scale.x = (node.scale.x / 1.05)
        node.scale.y = (node.scale.y / 1.05)



  create: ->
    that = @


    """
    Fetch topBar object from the scene
    """
    topBarObject = @parent.getObject("TopBar")



    """
    Create the background
    """
    background = @createBackground()
    @addChild background



    """
    Create a container for world map
    """
    @mapContainer = mapContainer = new Gotham.Graphics.Graphics
    mapContainer.interactive = true
    mapContainer.hitArea = new Gotham.Graphics.Rectangle 0,0,  @size.width, @size.height
    background.addChild(mapContainer)

    """
    Activate WheelScrolling on the mapContainer
    """
    GothamGame.renderer.pixi.addWheelScrollObject(mapContainer)

    """
    This function checks weither the panning has gones outside the bounds of the map
    Example: The map is dragged further east that russia, it should now stop
    """
    mapContainer.borderCheck = (offsetX, offsetY) ->
      offsetX*=-1
      offsetY*=-1

      if offsetX < 0
        mapContainer.position.x = 0
        mapContainer.offset.x -=  mapContainer.diff.x

        if mapContainer.isZoomOut
          mapContainer.offset.x += offsetX


      else if offsetX > that.size.width - that.originalScaledSize.width
        mapContainer.x = (that.size.width - that.originalScaledSize.width)*-1
        mapContainer.offset.x -= mapContainer.diff.x

        if mapContainer.isZoomOut
          mapContainer.offset.x -= (that.size.width - that.originalScaledSize.width) - offsetX

      if offsetY < 0
        mapContainer.y = 0
        mapContainer.offset.y -=  mapContainer.diff.y
        if mapContainer.isZoomOut
          mapContainer.offset.y += offsetY


      else if offsetY > that.size.height - that.originalScaledSize.height
        mapContainer.y = (that.size.height - that.originalScaledSize.height)*-1
        mapContainer.offset.y -=  mapContainer.diff.y

        if mapContainer.isZoomOut
          mapContainer.offset.y -= (that.size.height - that.originalScaledSize.height) - offsetY

    """
    Activate Panning - Return False and ignore if Longitude < -180 or > 180 and False if Latitude < -90 or > 90
    """
    mapContainer.activatePan(mapContainer.borderCheck)

    """
    MapContainers mouse move:
    * Calculates coordinate in lat,lng
    * Determines country based on lat,lng
    * Sets topBarText
    """
    mapContainer.mousemove =  (e) ->
      interactionManager = new PIXI.InteractionManager()
      if(interactionManager.hitTest(background, e))
        pos = e.getLocalPosition this
        @_lastMousePosition = pos
        posX = -(that.originalScaledSize.width / 2) + pos.x
        posY = -(that.originalScaledSize.height / 2) + pos.y

        lat = Math.max(Math.min((posY / that.getCoordFactors().latitude).toFixed(4), 90), -90)
        long = Math.max(Math.min((posX / that.getCoordFactors().longitude).toFixed(4), 180), -180)

        # Update currentCoordinates in WorldMap object
        that.currentCoordinates =
          latitude: lat
          longitude: long

        # Calculate which country it belongs to
        country = GothamGame.geocoding.getCountry(lat, long)

        topBarObject.coordinateText.setText(
          "Lat: " + lat +
          "\nLong: " + long
        )

        topBarObject.countryText.setText(
          "Country: " + if country then country.name else "None"
        )

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
      @isZoomOut = if direction == -1 then true else false

      # Scale Factor per scroll
      factor = 1.1

      # Calculate next scale step, also save the previous step
      prevScale =
        x : @scale.x
        y : @scale.y


      # Multiply Factor if zooming in, Divide if zooming out
      if not @isZoomOut
        nextScale =
          x : @scale.x * factor
          y : @scale.y * factor
      else
        nextScale =
          x : @scale.x / factor
          y : @scale.y / factor


      if nextScale.x < 1 or nextScale.y < 1 or nextScale.x > 10 or nextScale.y > 10
        @isZoomOut = false
        return

      # Update offsets
      if not @isZoomOut
        @offset.x *= factor
        @offset.y *= factor
      else
        @offset.x /= factor
        @offset.y /= factor


      # Calculate diff on width and heighy between the two
      prevSize = that.originalScaledSize
      nextSize =
        width : (that.originalScaledSize.width * nextScale.x)
        height : (that.originalScaledSize.height * nextScale.y)

      that.size = nextSize

      # Calculate the difference between previous size and nextSize
      diffSize =
        width: prevSize.width - nextSize.width
        height: prevSize.height - nextSize.height

      # Scale and Position the map accordingly
      @scale = nextScale

      ##############
      #
      # Scale Stuff
      #
      ##############
      that.scaleNodes @isZoomOut

      # Set position in center
      @position.x = (diffSize.width / 2) + @offset.x
      @position.y = (diffSize.height / 2) + @offset.y

      @borderCheck(@position.x, @position.y)
      @isZoomOut = false

    """
    Create World Map
    """
    worldMap = @createMap()
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
    middle.drawCircle((@originalSize.width / 2) / @originalMapScale.x, (@originalSize.height / 2) / @originalMapScale.y, 1);
    mapContainer.addChild middle






  createBackground: ->
    background = new Gotham.Graphics.Graphics
    background.lineStyle(2, 0x0000FF, 1)
    background.blendMode = PIXI.blendModes.ADD
    background.drawRect(0,0,  @size.width, @size.height)
    background.hitArea = new Gotham.Graphics.Rectangle 0,0,  @size.width, @size.height
    background._size = @size

    # Create mask background
    backgroundMask = new Gotham.Graphics.Graphics
    backgroundMask.beginFill(0x232323, 1)
    backgroundMask.drawRect(0,0,  @size.width, @size.height)
    @addChild backgroundMask
    background.mask = backgroundMask


    return background

  createMap: ->
    # Fetch JSON
    mapJson = Gotham.Preload.fetch("map", "json")

    # Create PolygonList
    polygonList = Gotham.Graphics.PolygonFromJSON(mapJson, 10, @originalMapScale)

    # Convert to Graphics objects
    graphicsList = Gotham.Graphics.PolygonToGraphics(polygonList, true)

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










module.exports = WorldMap