


class Loading extends Gotham.Graphics.Scene


  create: ->


    # Add Background to the screne
    background = Gotham.Graphics.Sprite.fromImage './assets/img/loading_background.jpg'
    background.x = 0
    background.y =  0
    background.width = 1920
    background.height = 1080
    @addChild background

    # Document Container
    @documentContainer = new Gotham.Graphics.Container()
    @addChild @documentContainer

    ###############
    ## Game Title##
    ###############
    @text = text = new Gotham.Graphics.Text("Loading, Please Wait\n0%", {font: "bold 90px calibri", fill: "#ffffff", stroke: "0x808080",strokeThickness: 6, align: "center"});
    text.position =
      x: 1920 / 2
      y: 1080 / 3
    text.anchor =
      x: 0.5
      y: 0.5
    tween = new Gotham.Tween text
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {alpha: 0}, 1500
    #tween.delay 5000
    tween.to {alpha: 1}, 1500
    tween.onStart ->
      console.log @ + " started!"
    tween.start()
    @addChild text
    #################
    ## Loading Bar ##
    #################
    #TODO



  addNetworkItem: ->


  addAsset: (name, type, percent) ->
    @_c = if not @_c then 0

    @text.text =  "Loading, Please Wait\n#{percent}%"


    random = (min, max) ->
      return Math.floor(Math.random() * (max - min)) + min;

    document = Gotham.Graphics.Sprite.fromImage './assets/img/file.png'
    document.x = -64
    document.y =  random(500, 800)
    document.width = 64 / document.scale.x
    document.height = 64 / document.scale.y

    title = new Gotham.Graphics.Text(type, {font: "bold 40px calibri", fill: "#000000", align: "center"});
    title.width = document.width / document.scale.x
    title.height = document.height / document.scale.y
    title.x = 15 / document.scale.x
    title.y = 5 / document.scale.y
    document.addChild title


    tween = new Gotham.Tween document
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.delay random(0, 10000)
    tween.to {position: x: 1960}, 10000
    tween.onStart ->
      #console.log "[STARTED] #{name}"
    tween.onComplete ->
      #console.log "[DONE] #{name}"
    tween.onUpdate (chain) ->

      # Sine curve
      amplitude = 1.5
      wavelenght = 0.01
      document.position.y = (document.position.y) + (Math.sin(document.position.x * wavelenght) * amplitude)
      #y = Math.sin()
    tween.start()

    @documentContainer.addChild document

    return

















    



module.exports = Loading