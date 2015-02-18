# Objects
WorldMap = require "./objects/WorldMap.coffee"
TopBar    = require "./objects/TopBar.coffee"

# Scenes
LoadingScene  = require "./scenes/Loading.coffee"
WorldScene    = require "./scenes/World.coffee"

class GothamGame

  window.GothamGame = GothamGame

  @renderer = new Gotham.Graphics.Renderer 1920, 1080, null, true

  # Static Stuff
  @objects =
    "WorldMap" : WorldMap
    "TopBar" : TopBar

  @scenes =
    "Loading" : LoadingScene
    "World"   : WorldScene


module.exports = GothamGame