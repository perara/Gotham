

class GothamGame

  window.GothamGame = GothamGame

  @renderer = new Gotham.Graphics.Renderer 1920, 1080, null, true

  # Database
  @Database = new Gotham.Database()

  # Networking
  @network = null

  # Geocoding Utilities
  @geocoding = require "./tools/Geocoding.coffee"

  # Game Objects
  @objects =
    "WorldMap" : require "./objects/WorldMap.coffee"
    "TopBar" : require "./objects/TopBar.coffee"
    "Settings" : require "./objects/Settings.coffee"
    "NodeList" : require "./objects/NodeList.coffee"
    "Terminal" : require "./objects/Terminal.coffee"

  # Game Scenes
  @scenes =
    "Loading" : require "./scenes/Loading.coffee"
    "World"   : require "./scenes/World.coffee"
    "Menu"    : require "./scenes/Menu.coffee"


module.exports = GothamGame