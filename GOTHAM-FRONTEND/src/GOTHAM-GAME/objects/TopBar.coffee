




class TopBar extends Gotham.Graphics.Container

  constructor: ->
    @name = "TopBar"
    super





  create: ->

    # Create Top Bar Texture
    topBarTexture = Gotham.Preload.fetch("topBar", "image")
    topBar = new PIXI.Sprite(topBarTexture);
    topBar.anchor =
      x: 0
      y: 0
    topBar.position.x = 0;
    topBar.position.y = 0;
    topBar.width = 1920
    topBar.height = 70
    @addChild(topBar)

    bottomBarTexture = Gotham.Preload.fetch("bottomBar", "image")
    bottomBar = new PIXI.Sprite(bottomBarTexture);
    bottomBar.anchor =
      x: 0
      y: 0
    bottomBar.position.x = 0;
    bottomBar.position.y = 1080 - 70;
    bottomBar.width = 1920
    bottomBar.height = 70
    @addChild(bottomBar)


    # Create LAT long text
    @coordinateText = new Gotham.Graphics.Text("Lat: 0\nLng: 0", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
    @coordinateText.position.x = topBar.width/2
    @coordinateText.position.y = 0
    @coordinateText.anchor =
      x: 0
      y: 0
    @addChild(@coordinateText)

    # Create LAT long text
    @countryText = new Gotham.Graphics.Text("Country: None", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
    @countryText.position.x = topBar.width/2 + 150
    @countryText.position.y = 15
    @countryText.anchor =
      x: 0
      y: 0
    @addChild(@countryText)





module.exports = TopBar