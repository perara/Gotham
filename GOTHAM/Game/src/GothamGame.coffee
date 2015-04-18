﻿

class GothamGame

  window.GothamGame = GothamGame

  @renderer = new Gotham.Graphics.Renderer 1920, 1080, {
    antialiasing:true
    transparent:false
    resolution:1
  }, true

  # Mission Engine
  @MissionEngine = new (require './engine/MissionEngine.coffee')()
  @Terminal = require './engine/Terminal/Terminal.coffee'

  # Mission Object
  @Mission = require './engine/Mission.coffee'
  @HackMission = require './engine/HackMission.coffee'

  @Tools =
    HostUtils: require './tools/HostUtils.coffee'

  # Networking
  @network = null

  # Game Objects
  @Controllers =
    Bar: require './objects/Controller/BarController.coffee'
    Terminal : require './objects/Controller/TerminalController.coffee'
    NodeList : require './objects/Controller/NodeListController.coffee'
    WorldMap : require './objects/Controller/WorldMapController.coffee'
    User : require './objects/Controller/UserController.coffee'
    Mission : require './objects/Controller/MissionController.coffee'

    #"WorldMap" : require "./objects/WorldMap.coffee"
    #"TopBar" : require "./objects/View/BarView.coffee"
    #"Settings" : require "./objects/Settings.coffee"
    #"NodeList" : require "./objects/NodeList.coffee"
    #"Terminal" : require "./objects/Terminal.coffee"

  # Game Scenes
  @scenes =
    "Loading" : require "./scenes/Loading.coffee"
    "World"   : require "./scenes/World.coffee"
    "Menu"    : require "./scenes/Menu.coffee"


module.exports = GothamGame