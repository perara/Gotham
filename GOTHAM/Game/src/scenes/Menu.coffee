
class Menu extends Gotham.Graphics.Scene

  create: ->
    that = @

    # Create Background
    @createBackground()

    # Document Container
    @documentContainer = new Gotham.Graphics.Container()
    @addChild @documentContainer

    # Singleplayer button
    @buttons = []
    @addButton "Single Player", ->
      GothamGame.Renderer.setScene "World"

    # Settings button
    @addButton "Settings", ->
      Settings = new GothamGame.Controllers.Settings "Settings"
      that.addObject Settings
      """object_settings = new GothamGame.objects.Settings
      object_settings.width = 1920
      object_settings.height = 1080
      object_settings.onInteractiveChange = (state) ->
        if !state
          that.removeObject object_settings
          that.setInteractive true

      that.addObject object_settings"""

    # About Button
    @addButton "About", ->

    # Gotham Button
    @addButton "Exit", ->
      window.location.href = "http://gotham.no";


    @drawButtons()
    #@setupMusic()




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

    tween = new Gotham.Tween gameTitle
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {rotation: 0.1, rotation: 0.1}, 1500
    tween.to {rotation: -0.1, rotation: -0.1}, 1500
    tween.start()


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
    sprite.buttonMode = true

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
      console.log ":D"
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