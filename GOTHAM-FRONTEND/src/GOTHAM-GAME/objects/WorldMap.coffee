

class WorldMap extends Gotham.Graphics.Container

  constructor: ->
    super
    that = @
    @name = "WorldMap"
    @setNetworkHub("worldMap")

    @originalMapScale =
      x: 3.84
      y: 3.06

    @originalSize =
      width: 7200
      height: 3600

    @originalScaledSize =
      width: @originalSize.width / @originalMapScale.x
      height: @originalSize.height / @originalMapScale.y

    @size = @originalScaledSize


    @size = @size




    # This callback returns a array with nodes from the server. These nodes should be processed by the WorldMap
    # A function which places these nodes must be used.
    @addNetworkMethod "fetchMap", (json) ->

      # Parse data as JSON
      nodes = JSON.parse json

      # Iterate through each of the nodes and add to the map
      for node in nodes
        that.addNode node

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

  addNode: (node) ->

    # Convert Longitude and Latitude to pixels
    posX = (node.lng * @getCoordFactors().longitude) + (@size.width / 2)
    posY = (node.lat * @getCoordFactors().latitude)  + (@size.height / 2)

    # Draw Dot
    nodeDot = new Gotham.Graphics.Graphics()
    nodeDot.lineStyle(0);
    nodeDot.beginFill(0xff0000, 1);
    nodeDot.drawCircle(posX, posY, 1);

    # Add the node dot to map
    @mapContainer.addChild nodeDot


  create: ->
    that = @

    # Create a background
    background = new Gotham.Graphics.Graphics
    background.lineStyle(2, 0x0000FF, 1)
    background.blendMode = PIXI.blendModes.ADD
    background.drawRect(0,0,  @size.width, @size.height)
    background.hitArea = new Gotham.Graphics.Rectangle 0,0,  @size.width, @size.height
    background._size = @size
    @addChild background

    @mapContainer = mapContainer = new Gotham.Graphics.Graphics
    mapContainer.interactive = true
    mapContainer.hitArea = new Gotham.Graphics.Rectangle 0,0,  @size.width, @size.height
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




    background.addChild(mapContainer)

    # Add Wheel Scrolling (Zooming)
    GothamGame.renderer.pixi.addWheelScrollObject(mapContainer)


    # Activate Panning - Return False and ignore if Longitude < -180 or > 180 and False if Latitude < -90 or > 90
    mapContainer.activatePan(mapContainer.borderCheck)

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

    mapContainer.onWheelScroll = (e) ->
      direction = e.wheelDeltaY / Math.abs(e.wheelDeltaY)

      # -1 = Wheel out, 1 = Wheen In
      mapContainer.isZoomOut = if direction == -1 then true else false

      # Scale Factor per scroll
      factor = 1.1

      # Calculate next scale step, also save the previous step
      prevScale =
        x : @scale.x
        y : @scale.y


      # Multiply Factor if zooming in, Divide if zooming out
      if not mapContainer.isZoomOut
        nextScale =
          x : @scale.x * factor
          y : @scale.y * factor
        @offset.x *= factor
        @offset.y *= factor
      else
        nextScale =
          x : @scale.x / factor
          y : @scale.y / factor
        @offset.x /= factor
        @offset.y /= factor


      if nextScale.x < 1 or nextScale.y < 1 or nextScale.x > 10 or nextScale.y > 10
        @isZoomOut = false
        return

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

      # Set position in center
      @position.x = (diffSize.width / 2) + @offset.x
      @position.y = (diffSize.height / 2) + @offset.y

      mapContainer.borderCheck(@position.x, @position.y)
      @isZoomOut = false







    # Create mask background
    backgroundMask = new Gotham.Graphics.Graphics
    backgroundMask.beginFill(0x232323, 1)
    backgroundMask.drawRect(0,0,  @size.width, @size.height)
    @addChild backgroundMask

    # Fetch the topBar scene object
    topBarObject = @parent.getObject("TopBar")

    # Fetch JSON
    mapJson = Gotham.Preload.fetch("map", "json")

    # Create PolygonList
    polygonList = Gotham.Graphics.PolygonFromJSON(mapJson, 10, @originalMapScale)

    # Convert to Graphics objects
    graphicsList = Gotham.Graphics.PolygonToGraphics(polygonList, true)

    # Add Each of the graphic objects to the world map
    background.mask = backgroundMask
    for graphics, key in graphicsList


      # GRAPHICS PRIMITE EDITION
      # Set bound padding to 0
      """graphics.boundsPadding = 0
      mapContainer.addChild graphics

      # Hovering the graphics object
      graphics.mouseover =  (e) ->
        this.clear()
        this.lineStyle(2, 0x000000, 1);
        #this.blendMode = PIXI.blendModes.ADD
        this.beginFill(0xffffff, 1);
        this.drawPolygon(this.polygon.points)

      # leave hovering the graphics object
      graphics.mouseout =  (e) ->
        this.clear()
        this.lineStyle(2, 0x000000, 1);
        this.beginFill(0xffffff, 0.5);
        this.blendMode = 0
        this.drawPolygon(this.polygon.points)
     """


      # SPRITE EDITION
      # Generate a normal texture
      texture = graphics.generateTexture()

      # Generate a hover texture
      graphics.clear()
      graphics.lineStyle(3, 0xFF0000, 1);
      graphics.blendMode = PIXI.blendModes.ADD
      graphics.drawPolygon(graphics.polygon.points)
      hoverTexture = graphics.generateTexture()

      # Create a sprite
      sprite = new Gotham.Graphics.Sprite texture
      sprite.normalTexture = texture
      sprite.hoverTexture = hoverTexture



      sprite.position.x = graphics.minX
      sprite.position.y = graphics.minY

      # Translate hitArea to correct position
      translatedPoints = []
      xory = 0
      for point in graphics.polygon.points
        if xory++ % 2 == 0
          translatedPoints.push(point - sprite.x)
        else
          translatedPoints.push(point - sprite.y)
      hitarea = new PIXI.Polygon translatedPoints
      sprite.hitArea = hitarea
      sprite.interactive = true
      # Translate hitArea end




      mapContainer.addChild sprite


      # Hovering the graphics object
      sprite.mouseover =  (e) ->
        @bringToFront()
        @texture = @hoverTexture


      sprite.mouseout =  (e) ->
        @texture = @normalTexture









    # Find center of the map
    middle = new Gotham.Graphics.Graphics()
    middle.lineStyle(0);
    middle.beginFill(0xff0000, 1);
    middle.drawCircle((@originalSize.width / 2) / @originalMapScale.x, (@originalSize.height / 2) / @originalMapScale.y, 1);
    mapContainer.addChild middle






module.exports = WorldMap