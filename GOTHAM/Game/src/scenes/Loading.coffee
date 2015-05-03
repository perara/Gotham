


class Loading extends Gotham.Graphics.Scene


  create: ->


    # Add Background to the screne
    background = Gotham.Graphics.Sprite.fromImage './assets/img/loading_background.jpg'
    background.x = 0
    background.y =  0
    background.width = 1920
    background.height = 1080
    background.anchor =
      x: 0.5
      y: 0.5
    background.position =
      x: background.width / 2
      y: background.height / 2
    background.scale =
      x: 1.4
      y: 1.4

    @addChild background

    tween = new Gotham.Tween background
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {
      scale:
        x: 1
        y: 1
    }, 20000
    tween.start()

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
      #console.log @ + " started!"
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


    if type == "Image"
      document = Gotham.Graphics.Sprite.fromImage './assets/img/load_image.png'
    else if type == "JSON"
      document = Gotham.Graphics.Sprite.fromImage './assets/img/load_json.png'
    else if type == "Data"
      document = Gotham.Graphics.Sprite.fromImage './assets/img/load_data.png'
    else if type == "Audio"
      document = Gotham.Graphics.Sprite.fromImage './assets/img/load_audio.png'

    document.x = -64
    document.y =  random(600, 900)
    document.alpha = 0.4

    tween = new Gotham.Tween document
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.delay random(0, 20000)
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