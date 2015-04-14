Gotham = require '../../GameFramework/src/Gotham.coffee'
GothamGame = require './GothamGame.coffee'
require './dependencies/jquery-ui.min'


setup =
  started: false

  database: ->
    # Create Node Table
    db_nodes = GothamGame.Database.createTable "node"

    # Create Cable Table
    db_cables = GothamGame.Database.createTable "cable"

    # Create Temp Table
    db_cables = GothamGame.Database.createTable "temp"
  preload: ->
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

  startGame: ->

    # Create Scenes
    scene_World = new GothamGame.scenes.World 0x333333, true
    scene_Menu  = new GothamGame.scenes.Menu 0x000000, true

    # Add Scenes to renderer
    GothamGame.renderer.addScene("World", scene_World)
    GothamGame.renderer.addScene("Menu", scene_Menu)

  startNetwork: ->
    GothamGame.network = new Gotham.Network "//localhost", 8081
    GothamGame.network.connect()

    GothamGame.network.onConnect = ->
      # Start game when connected
      if not setup.started
        setup.startGame()
        setup.started = true
    GothamGame.network.onReconnecting = ->
      console.log "Attempting to reconnect"
    GothamGame.network.onReconnect = ->
      console.log "Reconnected!"



# Setup Database
setup.database()

#Setup Preloading
setup.preload()



scene_Loading  = new GothamGame.scenes.Loading 0x3490CF, true

GothamGame.renderer.addScene("Loading", scene_Loading)

# Set Start Scene
GothamGame.renderer.setScene("Loading")


Gotham.Preload.onLoad (source, name, percent) ->
  scene_Loading.tick name
  console.log("Preload: " + percent + "%")

Gotham.Preload.onComplete () ->
  console.log "Preload: Complete"

  # Start networking when preloading is done
  setup.startNetwork()
