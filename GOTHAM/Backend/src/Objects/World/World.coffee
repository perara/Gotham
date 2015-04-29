Clock = require './Components/Clock.coffee'
IPViking = require './Components/IPViking.coffee'
Cyberfeed = require './Components/Cyberfeed.coffee'
HoneyCloud = require './Components/HoneyCloud.coffee'


###*
# World, is the world loop of the backend. Simulating traffic etc.
# @class World
# @module Backend
# @submodule Backend.World
###
class World

  constructor: ->

    ###*
    # The world clock
    # @property {Clock} Clock
    ###
    @Clock = new Clock()

    ###*
    # Cyberfeed stream of infested hosts
    # @property {Cyberfeed} Cyberfeed
    ###
    @Cyberfeed = new Cyberfeed()

    ###*
    # IPViking Attack map stream
    # @property {IPViking} IPViking
    ###
    @IPViking = new IPViking()

    ###*
    # HoneyCloud attackmap stream
    # @property {HoneyCloud} HoneyCloud
    ###
    @HoneyCloud = new HoneyCloud()


  ###*
  # Starts the world loop
  # @method start
  ###
  start: ->
   @Clock.start()
   @IPViking.connect() # http://map.ipviking.com/ | Contains attack data |
   #@HoneyCloud.connect() # http://map.honeynet.org/ | Contain Attack Live stream (Src --> Target) | IP Included
   #@Cyberfeed.connect() # http://globe.cyberfeed.net/ | Contains Virus Infection feed (Much Data) (No Source)



module.exports = World