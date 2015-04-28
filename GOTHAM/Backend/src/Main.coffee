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
  Util: require './Tools/Util.coffee'

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
  nodeList = Gotham.LocalDatabase.table("nodes")
  cableList = Gotham.LocalDatabase.table("cables")
  missionList = Gotham.LocalDatabase.table("missions")
  hostList = Gotham.LocalDatabase.table("hosts")
  """
  promises.push Gotham.Database.Model.Node.all(
    include: [
      {
        model: Gotham.Database.Model.Cable
        include: [Gotham.Database.Model.Node]
      }
    ]
  ).then (nodes)->
    for node in nodes
      nodeList.insert {id: node.id, node: node}

  promises.push Gotham.Database.Model.Cable.all(
    include: [
      {
        model: Gotham.Database.Model.Node
      }
      ]
  ).then (cables)->
    for cable in cables
      cableList.insert {id: cable.id, cable: cable}
  """
  promises.push Gotham.Database.Model.Mission.all(
    include: [
      {
        model: Gotham.Database.Model.MissionRequirement
      }
    ]
  ).then (missions)->
    for mission in missions
      missionList.insert {id: mission.id, mission: mission}

  promises.push Gotham.Database.Model.Network.all(
    include: [
      {
        model: Gotham.Database.Model.Host
      }
    ]
  ).then (hosts)->
    for host in hosts
      hostList.insert {id: host.id, host: host}


  start = performance()
  When.all(promises).then () ->
    log.info "Data loaded in #{((performance() - start) / 1000).toFixed(2)} Seconds"
    _c()


testing = ->


# Preload then start server
preload ->
  startServer()
  testing()
