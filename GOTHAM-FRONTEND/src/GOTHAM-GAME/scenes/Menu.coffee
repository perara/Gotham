
class Menu extends Gotham.Graphics.Scene

  create: ->
    @buttons = []

    @createBackground()

    @addButton "Single Player", ->
      GothamGame.renderer.setScene("World")
    @addButton "Settings"
    @addButton "About"
    @addButton "Exit"
    @drawButtons()


    @setupMusic()





  setupMusic: () ->
    sound = Gotham.Preload.fetch("menu_theme", "audio")
    sound.volume(0.5)
    sound.loop(true)
    sound.play()

  createBackground: () ->

    # Game Title
    @gameTitle = gameTitle = new Gotham.Graphics.Text("Gotham v1.0", {font: "bold 60px Podkova", fill: "#dd00ff", align: "center", stroke: "#FFFFFF", strokeThickness: 6});
    gameTitle.x = 1920 / 2
    gameTitle.y = 100
    gameTitle.anchor =
      x: 0.5
      y: 0.5

    tweenTo =
      scale:
        x: 2
        y: 2
      rotation: 0.1
    tweenBack =
      scale:
        x: 1
        y: 1
      rotation: -0.1
    tween = new Gotham.Tween gameTitle
    #tween2.startDelay 500
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Circular.InOut
    tween.to tweenTo, 1500
    tween.to tweenBack, 1500
    tween.onStart ->
      console.log @


    texture = Gotham.Preload.fetch("menu_background", "image")
    sprite = new Gotham.Graphics.Sprite texture
    sprite.width = 1920
    sprite.height = 1080
    @addChild sprite
    @addChild gameTitle



  addButton: (text, onClick) ->

    texture = Gotham.Preload.fetch("menu_button", "image")
    #hoverTexture = Gotham.Preload.fetch("button_texture_hover", "image")

    # Create a sprite
    sprite = new Gotham.Graphics.Sprite texture
    sprite.width = 350
    sprite.height = 200
    sprite.originalScale = sprite.scale
    sprite.anchor =
      x: 0.5
      y: 0.5
    sprite.interactive = true

    # Create a text object
    text = new Gotham.Graphics.Text(text, {font: "bold 70px Arial", fill: "#ffffff", align: "center"}, 0,0)

    # Ensure anchors are 0
    text.anchor =
      x: 0.5
      y: 0.5

    # Position the text centered in the sprite
    text.x = 0
    text.y = 0

    # Create Events
    sprite.mouseover = (mouseData) ->
      @scale =
        x: 0.8
        y: 0.8

    that = @
    sprite.mouseout = (mouseData) ->
      @scale = @originalScale

    sprite.click = (mouseData) ->
      onClick(mouseData)

    sprite.addChild text

    @buttons.push(sprite)

  drawButtons: () ->

    startX = (1920 / 2)
    startY = 250
    counter = 0
    for button in @buttons
      button.x = startX
      button.y = startY + (counter * (button.height + 10))
      counter++
      @addChild button









module.exports = Menu