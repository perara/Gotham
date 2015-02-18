

class WorldMap extends Gotham.Graphics.Container

  constructor: ->
    @name = "WorldMap"
    super


  mapScale =
    x: 3.84
    y: 2.87

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
    background.addChild(mapContainer)

    # Create mask background
    backgroundMask = new Gotham.Graphics.Graphics
    backgroundMask.beginFill(0x232323, 1)
    backgroundMask.drawRect(0,0,  @getScaleSize().width, @getScaleSize().height)
    @addChild backgroundMask

    # Make background interactive

    that = @
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
          "\nLat: " + lat +
          "\nLong: " + long
        )




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
        this.beginFill(0xffFF00, 0.5);
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

    # Add Zoom and Pan
    Gotham.GlobalInput(mapContainer, @scaleAndPanCallback)


  scaleAndPanCallback: (element, scaleFactor) ->
    # Multiplying the scaleFactor with required properties
    mapSize.height *= scaleFactor
    mapSize.width *= scaleFactor
    mapScale.x *= scaleFactor
    mapScale.y *= scaleFactor








module.exports = WorldMap