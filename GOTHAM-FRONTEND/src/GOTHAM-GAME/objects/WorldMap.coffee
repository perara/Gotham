

class WorldMap extends Gotham.Graphics.Container

  constructor: ->
    @name = "WorldMap"
    super


  mapScale =
    x: 3.84
    y: 3.06

  mapSize =
    width: 7200
    height: 3600


  getScaleSize: ->
    scaleSize =
      width: mapSize.width / mapScale.x
      height: mapSize.height / mapScale.y
    return scaleSize

  getCoordFactors: ->
    coordFactors =
      latitude: ((@getScaleSize().height / 2) / 90) * -1
      longitude: ((@getScaleSize().width / 2) / 180)
    return coordFactors


  getMapCoordinates: ->
    # Coordinate Definitions
    mapCoordinates =
      origo:
        x: (mapSize.width / 2) / mapScale.x
        y: (mapSize.height / 2) / mapScale.y
      north: # 90
        x: (mapSize.width / 2) / mapScale.x
        y: 0
      south: # -90
        x: (mapSize.width / 2) / mapScale.x
        y: mapSize.height / mapScale.y
      west: # -180 Long
        x: 0
        y: (mapSize.height / 2) / mapScale.y
      east: # 180 Long
        x: mapSize.width / mapScale.x
        y: (mapSize.height / 2) / mapScale.y
    return mapCoordinates


  create: ->
    that = @

    # Create a background
    background = new Gotham.Graphics.Graphics
    background.lineStyle(2, 0x0000FF, 1)
    background.blendMode = PIXI.blendModes.ADD
    background.drawRect(0,0,  @getScaleSize().width, @getScaleSize().height)
    background.hitArea = new Gotham.Graphics.Rectangle 0,0,  @getScaleSize().width, @getScaleSize().height
    background._size = @getScaleSize()
    @addChild background

    mapContainer = new Gotham.Graphics.Graphics
    mapContainer.interactive = true
    mapContainer.hitArea = new Gotham.Graphics.Rectangle 0,0,  @getScaleSize().width, @getScaleSize().height
    background.addChild(mapContainer)

    # Add Wheel Scrolling (Zooming)
    GothamGame.renderer.pixi.addWheelScrollObject(mapContainer)
    # Activate Panning
    mapContainer.activatePan()


    mapContainer.mousemove =  (e) ->
      interactionManager = new PIXI.InteractionManager()
      if(interactionManager.hitTest(background, e))
        pos = e.getLocalPosition this
        @_lastMousePosition = pos
        posX = -(that.getScaleSize().width / 2) + pos.x
        posY = -(that.getScaleSize().height / 2) + pos.y

        lat = Math.max(Math.min((posY / that.getCoordFactors().latitude).toFixed(4), 90), -90)
        long = Math.max(Math.min((posX / that.getCoordFactors().longitude).toFixed(4), 180), -180)

        topBarObject.coordinateText.setText(
          "Lat: " + lat +
            "\nLong: " + long
        )

    mapContainer.onWheelScroll = (e) ->
      direction = e.wheelDeltaY / Math.abs(e.wheelDeltaY)
      factor = (1 + direction * 0.1);

      # Calculate next scale step, also save the previous step
      prevScale =
        x : @scale.x
        y : @scale.y

      nextScale =
        x : @scale.x * factor
        y : @scale.y * factor

      if nextScale.x < 1 or nextScale.y < 1 or nextScale.x > 10 or nextScale.y > 10
        return

      # Calculate diff on width and heighy between the two
      prevSize = that.getScaleSize()
      nextSize =
        width : (that.getScaleSize().width * nextScale.x)
        height : (that.getScaleSize().height * nextScale.y)

      # Calculate the difference between previous size and nextSize
      diffSize =
        width: prevSize.width - nextSize.width
        height: prevSize.height - nextSize.height

      # Scale and Position the map accordingly
      @scale = nextScale

      # Add the Scale Factor to move position
      @_dx *= factor
      @_dy *= factor

      @position.x = (diffSize.width / 2) + @_dx
      @position.y = (diffSize.height / 2) + @_dy


    # Create mask background
    backgroundMask = new Gotham.Graphics.Graphics
    backgroundMask.beginFill(0x232323, 1)
    backgroundMask.drawRect(0,0,  @getScaleSize().width, @getScaleSize().height)
    @addChild backgroundMask

    # Fetch the topBar scene object
    topBarObject = @parent.getObject("TopBar")

    # Fetch JSON
    mapJson = Gotham.Preload.fetch("map", "json")

    # Create PolygonList
    polygonList = Gotham.Graphics.PolygonFromJSON(mapJson, 10, mapScale)

    # Convert to Graphics objects
    graphicsList = Gotham.Graphics.PolygonToGraphics(polygonList, true)

    # Add Each of the graphic objects to the world map
    for graphics, key in graphicsList
      graphics.mask = backgroundMask
      mapContainer.addChild graphics

      # Hovering the graphics object
      graphics.mouseover =  (e) ->
        this.clear()
        this.lineStyle(5, 0x0000FF, 1);
        this.blendMode = PIXI.blendModes.ADD
        this.drawPolygon(this.polygon.points)

      # leave hovering the graphics object
      graphics.mouseout =  (e) ->
        this.clear()
        this.lineStyle(1, 0x0000FF, 1);
        this.beginFill(0xffffff, 0.5);
        this.blendMode = 0
        this.drawPolygon(this.polygon.points)


    # Find center of the map
    middle = new Gotham.Graphics.Graphics()
    middle.lineStyle(0);
    middle.beginFill(0xff0000, 1);
    middle.drawCircle((mapSize.width / 2) / mapScale.x, (mapSize.height / 2) / mapScale.y, 1);
    mapContainer.addChild middle






module.exports = WorldMap