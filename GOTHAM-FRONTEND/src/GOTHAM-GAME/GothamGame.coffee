# Objects
WorldMap = require "./objects/WorldMap.coffee"
TopBar    = require "./objects/TopBar.coffee"
Settings    = require "./objects/Settings.coffee"

# Scenes
LoadingScene  = require "./scenes/Loading.coffee"
WorldScene    = require "./scenes/World.coffee"
MenuScene     = require "./scenes/Menu.coffee"

# Tools
Geocoding     = require "./tools/Geocoding.coffee"

class GothamGame

  window.GothamGame = GothamGame

  @renderer = new Gotham.Graphics.Renderer 1920, 1080, null, true
  @network = null
  @geocoding = Geocoding

  # Static Stuff
  @objects =
    "WorldMap" : WorldMap
    "TopBar" : TopBar
    "Settings" : Settings

  @scenes =
    "Loading" : LoadingScene
    "World"   : WorldScene
    "Menu"    : MenuScene


module.exports = GothamGame