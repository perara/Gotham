Gotham = require '../../GameFramework/src/Gotham.coffee'
GothamGame = require './GothamGame.coffee'
require './dependencies/jquery-ui.min'


setup =
  started: false



  preloadFonts: (_c)->
    # Just return if user is IE:
    userAgent = userAgent or navigator.userAgent
    if userAgent.indexOf('MSIE ') > -1 or userAgent.indexOf('Trident/') > -1
      _c()
      return false

    done = false


    # Export Google WebFont Config
    window.WebFontConfig =
    # Load some fonts from google
      google:
        families: ['Inconsolata', 'Pacifico', 'Orbitron', 'Droid Serif']

    # ... you can do something here if you'd like
      active: () ->
        if not done
          done = true
          _c()


    # Create a timeout if WebFonts hangs.
    setTimeout window.WebFontConfig.active(), 5000
    # Create script tag matching protocol
    s = document.createElement 'script'
    s.src = "#{if document.location.protocol is 'https:' then 'https' else 'http'}://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
    s.type = 'text/javascript'
    s.async = 'true'

    # Insert it before the first script tag
    s0 = (document.getElementsByTagName 'script')[0]
    s0.parentNode.insertBefore s, s0


  preload: ->
    # User Management
    Gotham.Preload.image("/assets/img/user_management_background.jpg", "user_management_background", "image")
    Gotham.Preload.image("/assets/img/user_management_frame.png", "user_management_frame", "image")
    Gotham.Preload.image("/assets/img/user_management_network_item.png","user_management_network_item", "image")
    Gotham.Preload.image("/assets/img/user_mangement_host.png","user_mangement_host", "image")


    # Mission
    Gotham.Preload.image("/assets/img/mission_background.jpg","mission_background", "image")
    Gotham.Preload.image("/assets/img/iron_button.jpg","iron_button", "image")
    Gotham.Preload.image("/assets/img/mission_spacer.png","mission_spacer", "image")
    Gotham.Preload.image("/assets/img/mission_item.png","mission_item", "image")
    Gotham.Preload.image("/assets/img/user_management_frame.png", "mission_frame", "image")

    # Node
    Gotham.Preload.image("/assets/img/node_details.png","node_details", "image")


    Gotham.Preload.image("/assets/img/map_marker.png", "map_marker", "image")
    Gotham.Preload.json("/assets/json/json.json", "map")
    Gotham.Preload.image("/assets/img/sea_background.png", "sea_background", "image")

    # Bar
    Gotham.Preload.image("/assets/img/bottomBar.png", "bottomBar", "image")
    Gotham.Preload.image("/assets/img/sidebar.png", "sidebar", "image")
    Gotham.Preload.image("/assets/img/topbar.png", "topBar", "image")

    # Bar icons
    Gotham.Preload.image("/assets/img/home.png", "home", "image")
    Gotham.Preload.image("/assets/img/mission.png", "mission", "image")
    Gotham.Preload.image("/assets/img/menu.png", "menu", "image")
    Gotham.Preload.image("/assets/img/inventory.png", "inventory", "image")
    Gotham.Preload.image("/assets/img/settings.png", "settings", "image")
    Gotham.Preload.image("/assets/img/help.png", "help", "image")
    Gotham.Preload.image("/assets/img/attack.png", "attack", "image")
    Gotham.Preload.image("/assets/img/cable.png", "cable", "image")
    Gotham.Preload.image("/assets/img/user.png", "user", "image")

    # Menu
    Gotham.Preload.image("/assets/img/menu_button.png", "menu_button", "image")
    Gotham.Preload.image("/assets/img/menu_button_hover.png", "menu_button_hover", "image")
    Gotham.Preload.image("/assets/img/menu_background.jpg", "menu_background", "image")
    Gotham.Preload.mp3("./assets/audio/menu_theme.mp3", "menu_theme")
    Gotham.Preload.mp3("./assets/audio/button_click_1.mp3", "button_click_1")


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
    Gotham.Preload.network("GetCables", Gotham.Database.table("cable"), socket)
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
    console.log "Connecting...."
    GothamGame.Network.onConnect = ->
      callback(GothamGame.Network)

    GothamGame.Network.onReconnecting = ->
      console.log "Attempting to reconnect"
    GothamGame.Network.onReconnect = ->
      GothamGame.Network.Socket.emit 'ReconnectLogin', {"username" : "per", "password": "per"}
      console.log "Reconnected!"



# Preload Google Fonts
setup.preloadFonts ->
  # Start networking, Callback to preload when done
  setup.startNetwork ->

    # Preload Assets
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



