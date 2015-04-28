##########################################################
##
## Require Stuff
##
##########################################################
## Third Party
performance = require 'performance-now'
When = require 'when'
log = require('log4js').getLogger("Main")

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

# http://stackoverflow.com/questions/14031763/doing-a-cleanup-action-just-before-node-js-exits
startServer = () ->

  # Start world
  Gotham.World.Start()

  server = Gotham.SocketServer
  server.SetDatabase(Gotham.Database)
  server.RegisterRoom new (require './Networking/Rooms/HostRoom.coffee')()
  server.RegisterRoom new (require './Networking/Rooms/UserRoom.coffee')()
  server.RegisterRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
  server.RegisterRoom new (require './Networking/Rooms/GeneralRoom.coffee')()
  server.RegisterRoom new (require './Networking/Rooms/MissionRoom.coffee')()
  server.RegisterRoom new (require './Networking/Rooms/Applications/TracerouteRoom.coffee')()
  server.RegisterRoom new (require './Networking/Rooms/Applications/PingRoom.coffee')()
  server.Start()

  server.onConnect = (_client) ->
    log.info "[SERVER] Client Connected #{_client.id}"
  server.onDisconnect = (_client) ->
    log.info "[SERVER] Client Disconnected #{_client.id}"

preload = (_c) ->
  promises = []

  fs = require 'fs'
  fs.readdirSync("#{__dirname}/Objects/World/Objects/").forEach (file) ->
    if file != "GothamObject.coffee"
      fullName = file
      # Remove Extension
      file = file.replace(/\.[^/.]+$/, "")

      promises.push Gotham.Database.Model[file].all().then (objs) ->
        # Require object class
        Object = require "./Objects/World/Objects/#{fullName}"

        # Create table
        db_obj = Gotham.LocalDatabase.table(file)
        db_obj.insert new Object(obj) for obj in objs



  start = performance()
  When.all(promises).then () ->
    log.info "Preload done in #{((performance() - start) / 1000).toFixed(2)} Seconds"
    _c()




# Preload then start server
preload ->
  #startServer()

