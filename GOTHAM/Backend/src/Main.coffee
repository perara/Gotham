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

  console.log hostList
  nodeId1 = hostList.data[0].host.dataValues.Network.dataValues.node
  nodeId2 = hostList.data[3].host.dataValues.Network.dataValues.node
  node1 = nodeList.find(id: nodeId1)
  node2 = nodeList.find(id: nodeId2)

  #ls = new Gotham.Micro.LayerStructure().makeHTTP()
  #ses = new Gotham.Micro.Session(node1,node2,ls)
  #print ses


###############################################################
############ Preload to LocalDB #############
###############################################################
promises = []

nodeList = Gotham.LocalDatabase.table("nodes")
cableList = Gotham.LocalDatabase.table("cables")
missionList = Gotham.LocalDatabase.table("missions")
hostList = Gotham.LocalDatabase.table("hosts")

#######################
##
## Preloading Node
##
#######################
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

#######################
##
## Preloading Cables
##
#######################
promises.push Gotham.Database.Model.Cable.all(
  include: [
    {
      model: Gotham.Database.Model.Node
    }
    ]
).then (cables)->
  for cable in cables
    cableList.insert {id: cable.id, cable: cable}

#######################
##
## Preloading Missions
##
#######################
promises.push Gotham.Database.Model.Mission.all(
  include: [
    {
      model: Gotham.Database.Model.MissionRequirement
    }
  ]
).then (missions)->
  for mission in missions
    missionList.insert {id: mission.id, mission: mission}

#######################
##
## Preloading Networks
##
#######################
promises.push Gotham.Database.Model.Host.all(
  include: [
    {model: Gotham.Database.Model.Network, include: [
      {model: Gotham.Database.Model.Node}
    ]}
  ]
  include: [
    {
      model: Gotham.Database.Model.Network
    }
  ]
).then (hosts)->
  for host in hosts
    hostList.insert {id: host.id, host: host}


start = performance()
When.all(promises).then () ->
  log.info "Data loaded in #{((performance() - start) / 1000).toFixed(2)} Seconds"
  startServer()

"""
runner = ->
  ############ Testing of pathfinder ############################
  start = nodeList.findOne({id: 17418}).node
  end = nodeList.findOne({id: 17464}).node

  solution = Traffic.Pathfinder.bStar(start, end)
  Traffic.Pathfinder.printSolution(solution)

    log.info "Data loaded in #{((performance() - start) / 1000).toFixed(2)} Seconds"


    ###############################################################
    ############### Link data ####################################
    ###############################################################

    nodeList = LocalDatabase.table("nodes")
    cableList = LocalDatabase.table("cables")


    ###############################################################
    ############ Testing of Traffic Engine #######################
    ###############################################################

    te = new Macro.TrafficEngine(cableList)
    te.updateLoad()


    ###############################################################
    ############ Testing of pathfinder ############################
    ###############################################################


    start = nodeList.findOne({id: 17418}).node
    end = nodeList.findOne({id: 17464}).node

    solution = Micro.Pathfinder.bStar(start, end)
    Micro.Pathfinder.printSolution(solution)


  else
    setTimeout(runner, 10)
  """
