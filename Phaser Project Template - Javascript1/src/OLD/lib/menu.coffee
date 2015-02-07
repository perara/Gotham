config = require './config.coffee'


class Menu

  constructor: (game)->
  
  
  preload: ->
   
  
 
  create: ->
    # Add background image
    @game.add.tileSprite(0, 0, @game.width, @game.height, 'menu_background');
  
  
    # Start Game menu sound
    audio = @game.add.audio('menu_theme', 0.1).play()
    audio.volume = 10
    
    # Add Volum Adjuster
    #new @game.getModule("volumeAdjuster")(@game)
    
  
  update: ->
    
  
  
  module.exports = Menu
