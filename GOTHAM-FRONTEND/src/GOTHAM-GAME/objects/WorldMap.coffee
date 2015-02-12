

class WorldMap extends Gotham.Graphics.Container

  constructor: ->
    @name = "WorldMap"
    super


  create: ->
    # Fetch JSON

    mapJson = Gotham.Preload.fetch("map", "json")

    # Create PolygonList
    polygonList = Gotham.Graphics.PolygonFromJSON(mapJson, 10, { x : 3.8, y: 3.4})

    # Convert to Graphics objects
    graphicsList = Gotham.Graphics.PolygonToGraphics(polygonList, true)



    for graphics, key in graphicsList
      @addChild graphics

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







module.exports = WorldMap