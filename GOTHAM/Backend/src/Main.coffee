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
  #testSession()


testSession = ->

  db_node = Gotham.LocalDatabase.table("Node")
  db_network = Gotham.LocalDatabase.table("Network")
  db_host = Gotham.LocalDatabase.table("Host")

  host1 = db_host.findOne(id: 2)
  host2 = db_network.findOne(id: 2362)

  # Make layers
  #ls = new Gotham.Micro.LayerStructure().makeHTTP()

  #Gotham.Micro.LayerStructure.HTTP()

  packets = ["Data of packet 1", "Packet 2 this is"]
  sess = new Gotham.Micro.Session(host1, host2, "ICMP")
  sess.setJumpDelay(1)
  #sess.setPorts(80)
  console.log JSON.stringify(sess)
