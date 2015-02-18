




class TopBar extends Gotham.Graphics.Container

  constructor: ->
    @name = "TopBar"
    super

    @coordinateText = new PIXI.Text("COUNT 4EVAR: 0", {font: "bold italic 60px Arvo", fill: "#3e1707", align: "center", stroke: "#a4410e", strokeThickness: 7});
    @coordinateText.position.x = 400
    @coordinateText.position.y = 300
    @coordinateText.anchor =
      x: 1,
      y: 1
    @addChild(@coordinateText)


  create: ->




    texture = Gotham.Preload.fetch("topBar", "image")
    bunny = new PIXI.Sprite(texture);
    bunny.anchor.x = 0
    bunny.anchor.y = 0;
    bunny.position.x = 0;
    bunny.position.y = 0;
    bunny.width = 1920
    bunny.height = 70
    @addChild(bunny)






module.exports = TopBar