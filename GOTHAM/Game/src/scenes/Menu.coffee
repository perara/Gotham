
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
    @gameTitle = gameTitle = new Gotham.Graphics.Text("Gotham", {font: "bold 100px Orbitron", fill: "#000000", align: "center", stroke: "#FFFFFF", strokeThickness: 4});
    gameTitle.x = 1920 / 2
    gameTitle.y = 125
    gameTitle.anchor =
      x: 0.5
      y: 0.5

    originalTitleScale =
      x: gameTitle.scale.x
      y: gameTitle.scale.y

    tween = new Gotham.Tween gameTitle
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {
      scale:
        x: originalTitleScale.x + 0.1
        y: originalTitleScale.y + 0.1
    }, 10000
    tween.to {
      scale:
        x: originalTitleScale.x
        y: originalTitleScale.y
    }, 10000
    tween.start()


    texture = Gotham.Preload.fetch("menu_background", "image")
    sprite = new Gotham.Graphics.Sprite texture
    sprite.width = 1920
    sprite.height = 1080
    sprite.anchor =
      x: 0.5
      y: 0.5
    sprite.position =
      x: sprite.width / 2
      y: sprite.height / 2

    originalScale =
      x: sprite.scale.x
      y: sprite.scale.y

    tween = new Gotham.Tween sprite
    tween.repeat(Infinity)
    tween.easing Gotham.Tween.Easing.Linear.None
    tween.to {
      scale:
        x: originalScale.x + 0.6
        y: originalScale.y + 0.6
    }, 25000
    tween.delay 10000
    tween.to {
      scale:
        x: originalScale.x
        y: originalScale.y
    }, 25000
    tween.start()



    @addChild sprite
    @addChild gameTitle



  addButton: (text, onClick) ->

    texture = Gotham.Preload.fetch("menu_button", "image")
    hoverTexture = Gotham.Preload.fetch("menu_button_hover", "image")


    # Create a sprite
    sprite = new Gotham.Graphics.Sprite texture
    sprite.width = 300
    sprite.height = 100
    sprite.originalScale = sprite.scale
    sprite.anchor =
      x: 0.5
      y: 0.5
    sprite.interactive = true
    sprite.buttonMode = true

    # Create a text object
    text = new Gotham.Graphics.Text(text, {font: "bold 70px Arial", fill: "#ffffff", align: "center", dropShadow: true }, 0,0)

    # Ensure anchors are 0
    text.anchor =
      x: 0.5
      y: 0.5

    # Position the text centered in the sprite
    text.x = 0
    text.y = 0

    # Create Events
    sprite.mouseover = (mouseData) ->
      @texture = hoverTexture
      @bringToFront()

      sound = Gotham.Preload.fetch("button_click_1", "audio")
      sound.volume(0.5)
      sound.loop(false)
      sound.play()


    that = @
    sprite.mouseout = (mouseData) ->
      @texture = texture

    sprite.click = (mouseData) ->

      onClick(mouseData)

    sprite.addChild text

    @buttons.push(sprite)

  drawButtons: () ->

    startX = (1920 / 2)
    startY = 350
    counter = 0
    for button in @buttons
      button.x = startX
      button.y = startY + (counter * (button.height + 10))
      counter++
      @addChild button









module.exports = Menu