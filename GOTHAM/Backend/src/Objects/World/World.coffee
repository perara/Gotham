Clock = require './Components/Clock.coffee'
IPViking = require './Components/IPViking.coffee'
Cyberfeed = require './Components/Cyberfeed.coffee'
HoneyCloud = require './Components/Honeycloud.coffee'

http = require 'http'



###*
# World, is the world loop of the backend. Simulating traffic etc.
# Litterature: http://howtonode.org/understanding-process-next-tick
# @class World
# @module Backend
# @submodule Backend.World
###
class World

  constructor: ->

    ###*
    # Data to output to the API
    # @property {Object} apiData
    ###
    @apiData =
      nodes: {}

    ###*
    # Sleep between each update loop
    # @property {FREQUENCY} Frequency
    # @private
    ###
    FREQUENCY = 5000

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
    # Updates the world state
    # @method update
    # @private
    ###
    that = @
    update = ->
      that.updateNodeLoad()

    setInterval(update, FREQUENCY)


  updateNodeLoad: ->
    db_node = Gotham.LocalDatabase.table "Node"


    node_load = {}

    for node in db_node.find()
      node.updateLoad()

      node_load[node.id] = node.load


      @apiData["nodes"][node.id] =
        load: node.load
        minutes: ((node.lng + 180) / 0.25)  + Gotham.World.Clock.getMinutes()
        lng: node.lng
        name: node.name



    # Send update to all clients
    for key, client of Gotham.SocketServer.getClients()
      client.Socket.emit 'NodeLoadUpdate', node_load




  ###*
  # Starts the world loop
  # @method start
  ###
  start: ->

    @Clock.start()
    @IPViking.connect() # http://map.ipviking.com/ | Contains attack data |
    #@HoneyCloud.connect() # http://map.honeynet.org/ | Contain Attack Live stream (Src --> Target) | IP Included
    #@Cyberfeed.connect() # http://globe.cyberfeed.net/ | Contains Virus Infection feed (Much Data) (No Source)
    @createAPI()

  ###*
  # Creates a World Statistics API
  # @method createAPI
  ###
  createAPI: ->
    that = @
    http.createServer((req, res) ->
      res.writeHead(200, {
        'Content-Type': 'application/json'
        'Access-Control-Allow-Origin': '*'
      })
      res.end(JSON.stringify(that.apiData))
    ).listen(9615);



module.exports = World