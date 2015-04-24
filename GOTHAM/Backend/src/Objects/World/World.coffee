Clock = require './Components/Clock.coffee'
IPViking = require './Components/IPViking.coffee'

class World

  constructor: ->
    @Clock = new Clock()
    @IPViking = new IPViking()


  # Start world events
  Start: ->
   @Clock.Start()
   @IPViking.Connect()



module.exports = World