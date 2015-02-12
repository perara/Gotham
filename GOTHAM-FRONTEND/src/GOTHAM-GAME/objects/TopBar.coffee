




class TopBar extends Gotham.Graphics.Container

  constructor: ->
    @name = "TopBar"
    super


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