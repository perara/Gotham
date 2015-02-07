# CoffeeScript
# This is a simple adjustment pin for volume in the game
config = require './config.coffee'



class VolumeAdjuster


  constructor: (game)->
    @game = game # Bind game to this
    @create() # Create game button
  
  create: ->
    @game.add.sprite 20, 20, 'circle'
    
  update: ->
    
  
  
  
    
module.exports = VolumeAdjuster
