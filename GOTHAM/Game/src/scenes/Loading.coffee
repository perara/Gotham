


class Loading extends Gotham.Graphics.Scene


  create: ->

    # Add Game name to middle of the scene
    text = new Gotham.Graphics.Text("Loading, Please Wait", {font: "bold 90px calibri", fill: "#ffffff", align: "left"});
    text.position =
      x: 1920 / 2
      y: 1080 / 2
    text.anchor =
      x: 0.5
      y: 0.5
    tween = new Gotham.Tween text
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {alpha: 0}, 1500
    tween.delay 2000
    tween.to {alpha: 1}, 1500
    tween.onStart ->
      console.log @ + " started!"
    tween.start()


    setTimeout(->
      tween.pause()

    , 2000)

    setTimeout(->
      tween.unpause()

    , 4000)

    @addChild text


  tick: (name) ->

    document = Gotham.Graphics.Sprite.fromImage './assets/img/file.png'
    document.x = -64
    document.y = Math.floor(Math.random() * 900) + 100
    document.width = 64 / document.scale.x
    document.height = 64 / document.scale.y

    tween = new Gotham.Tween document
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {position: x: 1960}, 10000
    tween.onStart ->
      console.log "[STARTED] #{name}"
    tween.onComplete ->
      console.log "[DONE] #{name}"
    #tween.start()


    @addChild document





    return

















    



module.exports = Loading