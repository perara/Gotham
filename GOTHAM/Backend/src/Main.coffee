cfg     =     require './config.json'
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'
Micro = require './Objects/Traffic/Micro/Micro.coffee'
Macro = require './Objects/Traffic/Macro/Macro.coffee'
LocalDatabase = require './Database/LocalDatabase.coffee'
performance = require 'performance-now'
When = require 'when'
log = require('log4js').getLogger("Main")

database = new Database()

startServer = () ->
  server = new SocketServer 8081
  server.SetDatabase database
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



###############################################################
############ Preload to LocalDB #############
###############################################################
promises = []


nodeList = LocalDatabase.table("nodes")
cableList = LocalDatabase.table("cables")


promises.push database.Model.Node.all(
  include: [
    {
      model: database.Model.Cable
      include: [database.Model.Node]
    }
  ]
).then (nodes)->
  for node in nodes
    nodeList.insert {id: node.id, node: node}


promises.push database. Model.Cable.all(
  include: [
    {
      model: database.Model.Node
    }
    ]
).then (cables)->
  for cable in cables
    cableList.insert {id: cable.id, cable: cable}


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
