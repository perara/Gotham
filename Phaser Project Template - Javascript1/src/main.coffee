State = require './lib/state.coffee'
Preload = require './lib/preload.coffee'
Menu = require './lib/menu.coffee'
config = require './lib/config.coffee'
VolumeAdjuster = require './lib/VolumeAdjuster.coffee'


$(document).ready ->
  
  # Create game object
  game = new Phaser.Game config.width, config.height, Phaser.AUTO
  
  # Add States
  game.state.add 'preload', Preload, yes
  game.state.add 'game', State, yes
  game.state.add 'menu', Menu, yes
  
  # Set Initial State
  game.state.start('preload')
  
  # Function for adding modules to the game object
  game.addModule = (moduleName, moduleObject) ->
    if !game.modules
      game.modules = {}

    game.modules[moduleName] = moduleObject
    
  game.getModule = (moduleName) ->
    if !game.modules[moduleName]
      console.log "Could not find module " + moduleName
    return game.modules[moduleName]
    
    
  # Add Modules
  game.addModule "volumeAdjuster", VolumeAdjuster
    
  
      
      
  
  
  
  $(window).resize ->
    game.width = $(window).width();
    game.height = $(window).height();
