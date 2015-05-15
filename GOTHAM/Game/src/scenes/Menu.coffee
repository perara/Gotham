

###*
# THe menu scene is running after the loading scene. Options are to Play Game ,
# @class Menu
# @module Frontend.Scenes
# @namespace GothamGame.Scenes
# @extends Gotham.Graphics.Scene
###
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
    @addButton "Play Game", ->
      GothamGame.Renderer.setScene "World"

    # Settings button
    @addButton "Settings", ->
      Settings = new GothamGame.Controllers.Settings "Settings"
      that.addObject Settings


    # About Button
    ready = true
    @addButton "Credits", ->
      if ready
        ready = false
      else
        return

      # Credits
      # [0] = Text
      # [1] = Size
      # [2] = Delay
      credits = [
        ["                 Introducing               ", 60, 0],
        ["Project Development       Per-Arne Andersen", 40, 0],
        ["Project Development       Paul Richard Lilleland", 40, 0],
        ["                                                ", 40, 1000],
        ["                   Thanks to                    ", 60, 0],
        ["Supervisor                 Christian Auby       ", 60, 0],
        ["Supervisor                 Sigurd Kristian Brinch", 60, 0],
        ["Assisting Supervisor       Morten Goodwin       ", 60, 0],
        ["                                                ", 40, 1000],
        ["              Special Thanks to                 ", 60, 0],
        ["Library Provider          PIXI.js Team          ", 40, 0],
        ["Library Provider          Howler.js Team        ", 40, 0],
        ["Library Provider          Socket.IO Team        ", 40, 0],
        ["Library Provider          JQuery Team           ", 40, 0],
        ["Library Provider          Sequelize Team        ", 40, 0],
        ["Library Provider          TaffyDB Team          ", 40, 0],
        ["Library Provider          nHibernate Team       ", 40, 0],
        ["                                                ", 40, 1000],
        ["               Other Technologies               ", 60, 0],
        ["                    MariaDB                     ", 60, 0],
        ["                    nginx                       ", 60, 0],
        ["                  Google Maps                   ", 60, 0],
        ["                    Node.JS                     ", 60, 0],

      ]

      i = 0
      intervalID = setInterval (()->

        item = credits[i++]

        text = new Gotham.Graphics.Text(item[0], {font: "bold #{item[1]}px calibri", stroke: "#000000", strokeThickness: 4, fill: "#ffffff", align: "left", dropShadow: true});
        text.anchor =
          x: 0.5
          y: 0.5
        text.x = 1920 / 2
        text.y = 1080
        text.alpha = 0
        that.addChild text

        tween = new Gotham.Tween text
        tween.delay item[2]
        tween.to {y: 800, alpha: 1}, 2000
        tween.to {y: 300}, 7000
        tween.to {y: 200, alpha: 0}, 1300
        tween.onComplete ()->
          that.removeChild text
        tween.start()

        if i >= credits.length
          ready = true
          clearInterval intervalID
      ),1000




    # Gotham Button
    @addButton "Exit", ->
      window.location.href = "http://gotham.no";


    @drawButtons()
    @setupMusic()




  setupMusic: () ->
    sound = Gotham.Preload.fetch("menu_theme", "audio")
    sound.volume(0.5)
    sound.loop true
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
        x: originalTitleScale.x + 0.2
        y: originalTitleScale.y + 0.2
    }, 10000
    tween.to {
      scale:
        x: originalTitleScale.x
        y: originalTitleScale.y
    }, 10000
    tween.start()


    texture = Gotham.Preload.fetch("menu_background", "image")
    texture2 = Gotham.Preload.fetch("menu_background2", "image")
    textures = [texture, texture2]
    swap = ->
      next = textures.shift()
      textures.push next
      return next

    sprite = new Gotham.Graphics.Sprite swap()
    sprite.width = 1920
    sprite.height = 1080
    sprite.alpha = 1
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
        x: originalScale.x + 0.8
        y: originalScale.y + 0.8
    }, 80000
    tween.delay(2000)
    tween.to {
      alpha: 0
    }, 5000
    tween.to {
      scale:
        x: originalScale.x
        y: originalScale.y
    }, 1
    tween.func ->
      sprite.texture = swap()
    tween.to {
        alpha: 1
      }, 2000


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