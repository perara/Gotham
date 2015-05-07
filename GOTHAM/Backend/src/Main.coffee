##########################################################
##
## Require Stuff
##
##########################################################
## Third Party
performance = require 'performance-now'
log = require('log4js').getLogger("Main")

# Extensions
require './Tools/JSON.coffee'

# Gotham Party
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'
LocalDatabase = require './Database/LocalDatabase.coffee'
World = require './Objects/World/World.coffee'

#########################################################
##
## Global Scope
##
#########################################################
global.Gotham =
  Database: new Database()
  LocalDatabase: new LocalDatabase()
  World: new World()
  SocketServer: new SocketServer 8081
  Micro: require './Objects/Traffic/Micro/Micro.coffee'
  Util: require './Tools/Util.coffee'

# http://stackoverflow.com/questions/14031763/doing-a-cleanup-action-just-before-node-js-exits
startServer = () ->

  # Start world
  Gotham.World.start()

  server = Gotham.SocketServer
  server.setDatabase(Gotham.Database)
  server.registerRoom new (require './Networking/Rooms/HostRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/UserRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/GeneralRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/MissionRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/Applications/TracerouteRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/Applications/PingRoom.coffee')()
  server.start()

  server.onConnect = (_client) ->
    log.info "[SERVER] Client Connected #{_client.id}"
  server.onDisconnect = (_client) ->
    log.info "[SERVER] Client Disconnected #{_client.id}"

preload = (_c) ->
  start = performance()
  Gotham.LocalDatabase.preload ->
    log.info "Preload done in #{((performance() - start) / 1000).toFixed(2)} Seconds"
    _c()





# Preload then start server
preload ->
  startServer()



  """
  console.log "EGPT"

  db_node = Gotham.LocalDatabase.table "Node"
  nodes = db_node.find()

  errors = []

  count = 0

  for _n1 in nodes
    for _n2 in nodes
      if count % 100000 then console.log(count, " nodes tested")
      new Gotham.Micro.Pathfinder.bStar _n1,_n2, 1, 1, (startId, goalId) ->
        errors.push ("Fail on: {startId}, {goalId}")
        console.log errors.pop()

  for e in errors
    console.log e
  """



