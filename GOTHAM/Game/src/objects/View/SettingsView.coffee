

###*
# SettingsView shows the setting panel
# @class SettingsView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class SettingsView extends Gotham.Pattern.MVC.View


  create: ->
    that = @

    # Frame of the panel
    spriteContainer = new Gotham.Graphics.Sprite Gotham.Preload.fetch("settings_background", "image")
    spriteContainer.width = 1920 * 0.80
    spriteContainer.height = 1080 * 0.80
    spriteContainer.x = 1920 * 0.10
    spriteContainer.y = 1080 * 0.10
    spriteContainer.interactive = true
    @addChild spriteContainer



    ################################################
    # Settings TOP Bar
    ################################################
    # Container
    topBarTexture = Gotham.Preload.fetch "topBar", "image"
    topBar = new PIXI.Sprite topBarTexture
    topBar.position.x = 0;
    topBar.position.y = 0;
    topBar.width = 1920
    topBar.height = 1080 * 0.10
    topBar.setInteractive true

    spriteContainer.addChild topBar

    # Title definition
    topBar_Title = new Gotham.Graphics.Text("Settings",{font: "bold 20px Arial", fill: "#ffffff", align: "left"})
    topBar_Title.x = (topBar.width / 4) + (topBar_Title.width / 2)
    topBar_Title.y = topBar.height / 4 - (topBar_Title.height / 2)
    topBar.addChild topBar_Title

    # Close Button definition
    topBar_Close = new Gotham.Graphics.Sprite Gotham.Preload.fetch "settings_close", "image"
    topBar_Close.width = 64
    topBar_Close.height = 64
    topBar_Close.x = topBar.width - topBar_Close.width
    topBar_Close.y = 0
    topBar_Close.interactive = true
    spriteContainer.addChild topBar_Close # TODO - Should be in the topBar container....

    # Start hover on close button
    topBar_Close.mouseover = ->
      @tint = 0xFF0000

    # Removed Hover from Close button
    topBar_Close.mouseout = ->
      @tint = 0xFFFFFF

    # When Close button is clicked
    topBar_Close.click = (data) ->
      that.parent.removeObject that.Controller


    ##########################################################
    ###
    ###
    ### Settings controls
    ###
    ##########################################################

    soundLevelTitle = new Gotham.Graphics.Text("Sound Volume",{font: "bold 20px Arial", fill: "#ffffff", align: "left"})
    soundLevelTitle.x = 400
    soundLevelTitle.y = 180
    spriteContainer.addChild soundLevelTitle

    soundLevel = new Gotham.Controls.Slider(Gotham.Preload.fetch("map_marker", "image"), Gotham.Preload.fetch("slider_background", "image"))
    soundLevel.x = 350
    soundLevel.y = 210
    soundLevel.width = 500
    soundLevel.height = 100
    soundLevel.onProgress = (progress) ->
      # Change sound level for all loaded audios
      for audio in Gotham.Preload.getDatabase("audio").find()
        audio.object.volume (progress/100)







    spriteContainer.addChild soundLevel



module.exports = SettingsView