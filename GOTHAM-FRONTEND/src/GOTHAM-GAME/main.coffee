# TEST IF PIXIv3 is READY...

#PIXXU = require './dependencies/pixi3.js'
#class Polygon extends PIXXU.Polygon
#console.log PIXXU


################################################
##
##
## Dependencies
##
##
################################################
# Gotham Library
Gotham = require '../GOTHAM-GF/src/Gotham.coffee'

# Include GothamGame
GothamGame = require '../GOTHAM-GAME/GothamGame.coffee'


require './dependencies/jquery-ui.min'


################################################
##
##
## Database
##
##
################################################
# Create Node Table
db_nodes = GothamGame.Database.createTable "node"

# Create Cable Table
db_cables = GothamGame.Database.createTable "cable"

################################################
##
##
## Preloading
##
##
################################################
# World Map
Gotham.Preload.image("/assets/img/map_marker.png", "map_marker", "image")
Gotham.Preload.json("/assets/json/json.json", "map")

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

#NodeList
Gotham.Preload.image("/assets/img/nodelist_background.jpg", "nodelist_background", "image")

#Terminal
Gotham.Preload.image("/assets/img/terminal_background.png", "terminal_background", "image")

################################################
##
##
## Game Initialization
##
##
################################################



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

