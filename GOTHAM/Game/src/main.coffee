Gotham = require '../../GameFramework/src/Gotham.coffee'
GothamGame = require './GothamGame.coffee'
require './dependencies/jquery-ui.min'

setup =
  started: false

  database: ->
    # Create Node Table
    db_nodes = Gotham.Database.createTable "node"

    # Create Cable Table
    db_cables = Gotham.Database.createTable "cable"

    # Create Host Table
    db_host = Gotham.Database.createTable "user"

    # Create Mission Table
    db_mission = Gotham.Database.createTable "mission"

    # Create Temp Table
    db_temp = Gotham.Database.createTable "temp"


  preload: ->
    # User Management
    Gotham.Preload.image("/assets/img/user_management_background.jpg", "user_management_background", "image")
    Gotham.Preload.image("/assets/img/user_management_frame.png", "user_management_frame", "image")
    Gotham.Preload.image("/assets/img/user_management_network_item.png","user_management_network_item", "image")

    # Mission
    Gotham.Preload.image("/assets/img/mission_background.jpg","mission_background", "image")
    Gotham.Preload.image("/assets/img/iron_button.jpg","iron_button", "image")
    Gotham.Preload.image("/assets/img/mission_spacer.png","mission_spacer", "image")
    Gotham.Preload.image("/assets/img/mission_item.png","mission_item", "image")
    Gotham.Preload.image("/assets/img/user_management_frame.png", "mission_frame", "image")

    # World Map
    Gotham.Preload.image("/assets/img/home.png", "home", "image")
    Gotham.Preload.image("/assets/img/map_marker.png", "map_marker", "image")
    Gotham.Preload.json("/assets/json/json.json", "map")
    Gotham.Preload.image("/assets/img/sea_background.jpg", "sea_background", "image")

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

  networkPreload: ->
    socket = GothamGame.Network

    Gotham.Preload.network("GetNodes", Gotham.Database.table("node"), socket)
    #Gotham.Preload.network("GetCables", Gotham.Database.table("cable"), socket)
    Gotham.Preload.network("GetUser", Gotham.Database.table("user"), socket)
    Gotham.Preload.network("GetMission", Gotham.Database.table("mission"), socket)

  startGame: ->

    # Create Scenes
    scene_World = new GothamGame.Scenes.World 0xffffff, true #0x333333, true
    scene_Menu  = new GothamGame.Scenes.Menu 0x000000, true

    # Add Scenes to renderer
    GothamGame.Renderer.addScene("World", scene_World)
    GothamGame.Renderer.addScene("Menu", scene_Menu)

    # Transfer all flying loading documents from Loading Scene to Menu Scene
    scene_Menu.documentContainer.addChild GothamGame.Renderer.getScene("Loading").documentContainer

    # Set Menu Scene
    GothamGame.Renderer.setScene("World")

  startNetwork: (callback) ->
    GothamGame.Network = new Gotham.Network "128.39.148.43", 8081
    GothamGame.Network.connect()
    GothamGame.Network.onConnect = ->
      callback(GothamGame.Network)

    GothamGame.Network.onReconnecting = ->
      console.log "Attempting to reconnect"
    GothamGame.Network.onReconnect = ->
      console.log "Reconnected!"



# Setup Database
setup.database()



# Start networking, Callback to preload when done
setup.startNetwork ->
  # Start asset loading
  setup.preload()

  GothamGame.Network.Socket.emit 'Login', {"username" : "per", "password": "per"}
  GothamGame.Network.Socket.on 'Login', (reply) ->
    if reply.status == 200
      # Start Network Preloading
      setup.networkPreload()


scene_Loading  = new GothamGame.Scenes.Loading 0x3490CF, true

GothamGame.Renderer.addScene("Loading", scene_Loading)

# Set Start Scene
GothamGame.Renderer.setScene("Loading")


Gotham.Preload.onLoad = (source,type, name, percent) ->
  scene_Loading.addAsset name, type, Math.round(percent)
  #console.log("Preload: " + percent + "%")

Gotham.Preload.onComplete = () ->
  console.log "Preload: Complete.. Starting Game"
  #Gotham.Tween.clear()
  if not setup.started
    setup.startGame()
  setup.started = true



