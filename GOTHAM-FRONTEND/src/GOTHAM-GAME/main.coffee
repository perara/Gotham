# TEST IF PIXIv3 is READY...

#PIXXU = require './dependencies/pixi3.js'
#class Polygon extends PIXXU.Polygon
#console.log PIXXU

# Gotham Library
Gotham = require '../GOTHAM-GF/Gotham.coffee'

# Scene Manager
GothamGame = require '../GOTHAM-GAME/GothamGame.coffee'

# World Map
Gotham.Preload.image("/assets/img/map_marker.png", "map_marker", "image")

# Top Bar
Gotham.Preload.image("/assets/img/bottomBar.png", "bottomBar", "image")
Gotham.Preload.image("/assets/img/topbar.png", "topBar", "image")

# Menu
Gotham.Preload.image("/assets/img/menu_button_texture.png", "menu_button", "image")
Gotham.Preload.image("/assets/img/menu_background.jpg", "menu_background", "image")
Gotham.Preload.mp3("./assets/audio/menu_theme.mp3", "menu_theme")

# Settings
Gotham.Preload.image("/assets/img/settings_background.jpg", "settings_background", "image")
Gotham.Preload.image("/assets/img/settings_close.png", "settings_close", "image")

Gotham.Preload.json("/assets/json/json.json", "map")
#Gotham.Preload.image("http://www.joomlaworks.net/images/demos/galleries/abstract/7.jpg", "item", "jpg")
#Gotham.Preload.image("http://blog.queensland.com/wp-content/uploads/2013/08/damien-leze_wide_angle_1.jpg", "item", "jpg")
#Gotham.Preload.image("http://static3.businessinsider.com/image/52cddfb169beddee2a6c2246/the-29-coolest-us-air-force-images-of-the-year.jpg", "item", "jpg")

#Gotham.Preload.mp3("./assets/audio/menu.mp3", "boud")
#sound = Gotham.Preload.fetch("boud", "audio", volume: 0.2)
#sound.volume(0.3)
#console.log sound
#sound.play()

# START GAME -----------------------------------

# OnLoad Callback
Gotham.Preload.onLoad (source, name, percent) ->
  console.log("Preload: " + percent + "%")

# OnComplete CallBack
Gotham.Preload.onComplete () ->
  console.log "Preload: Complete"

  # Activate Network, And connect. Continue loading when done
  GothamGame.network = new Gotham.Network "128.39.148.43", 8091, "gotham"
  GothamGame.network.connect (startConnection) ->

    # Create World Scene
    scene_World = new GothamGame.scenes.World 0x333333, true
    scene_Menu  = new GothamGame.scenes.Menu 0x000000, true

    # Add Scenes to renderer


    GothamGame.renderer.addScene("World", scene_World)
    GothamGame.renderer.addScene("Menu", scene_Menu)



    GothamGame.renderer.setScene("World")

    # Finally start the Connection
    connection = startConnection()


