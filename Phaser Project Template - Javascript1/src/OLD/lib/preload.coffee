# CoffeeScript
config = require './config.coffee'


class Preload

  constructor: (game)->
  
  
  preload: ->
    preloadBar = @game.add.sprite config.width / 2, config.height / 2, 'preload'
    preloadLabel = @game.add.text config.width / 2, (config.height / 2) + 50, "0%", { font: "30px Arial", fill: "#ffffff"}
    
    @game.load.setPreloadSprite preloadBar, 0
  
    @game.load.onFileComplete.add (progress) ->
      preloadLabel.text = progress + "%"
    
  
  
    # Preload all images
    @game.load.image imageName, path for imageName, path of config.images
    
    # Preload all Music
    @game.load.audio audioName, path for audioName, path of config.audio
    
    
    
  
 
  create: ->
    @game.state.start('menu')

  update: ->
  
  
  module.exports = Preload
