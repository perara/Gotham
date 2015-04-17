cfg     =     require './config.json'
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'
Traffic = require './Objects/Traffic/Traffic.coffee'
LocalDatabase = require './Database/LocalDatabase.coffee'
log = require('log4js').getLogger("Main")


database = new Database()
server = new SocketServer 8081
server.SetDatabase database
server.RegisterRoom new (require './Networking/Rooms/HostRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/UserRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/GeneralRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/MissionRoom.coffee')()
server.Start()
server.onConnect = (_client) ->
  log.info "[SERVER] Client Connected #{_client.id}"
server.onDisconnect = (_client) ->
  log.info "[SERVER] Client Disconnected #{_client.id}"
