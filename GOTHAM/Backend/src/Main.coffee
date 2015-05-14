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
  server.registerRoom new (require './Networking/Rooms/ShopRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/Applications/TracerouteRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/Applications/PingRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/AdministrationRoom.coffee')()
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

  db_host = Gotham.LocalDatabase.table("Host")
  db_network = Gotham.LocalDatabase.table("Network")

  source = db_host.findOne(id: 17)
  target = db_network.findOne(id: 500)

  session = new Gotham.Micro.Session(source, target, "ICMP")
  session.addPacket(new Gotham.Micro.Packet("8", true, 1, 1000))
  session.addPacket(new Gotham.Micro.Packet("0", false, 1, 0))
  session.addPacket(new Gotham.Micro.Packet("8", true, 2, 1000))
  session.addPacket(new Gotham.Micro.Packet("0", false, 2, 0))




  for key, val of session.nodeHeaders
    console.log key
    console.log val


























