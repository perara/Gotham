Clock = require './Components/Clock.coffee'
IPViking = require './Components/IPViking.coffee'
Cyberfeed = require './Components/Cyberfeed.coffee'
HoneyCloud = require './Components/HoneyCloud.coffee'

class World

  constructor: ->
    @Clock = new Clock()
    @Cyberfeed = new Cyberfeed()
    @IPViking = new IPViking()
    @HoneyCloud = new HoneyCloud()


  # Start world events
  Start: ->
   @Clock.Start()
   @IPViking.Connect() # http://map.ipviking.com/ | Contains attack data |
   #@HoneyCloud.Connect() # http://map.honeynet.org/ | Contain Attack Live stream (Src --> Target) | IP Included
   #@Cyberfeed.Connect() # http://globe.cyberfeed.net/ | Contains Virus Infection feed (Much Data) (No Source)



module.exports = World