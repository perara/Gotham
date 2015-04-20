cfg     =     require './config.json'
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'
Micro = require './Objects/Traffic/Micro/Micro.coffee'
Macro = require './Objects/Traffic/Macro/Macro.coffee'
LocalDatabase = require './Database/LocalDatabase.coffee'
performance = require 'performance-now'
log = require('log4js').getLogger("Main")

database = new Database()
server = new SocketServer 8081
server.SetDatabase database
server.RegisterRoom new (require './Networking/Rooms/HostRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/UserRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/GeneralRoom.coffee')()
server.Start()
server.onConnect = (_client) ->
  log.info "[SERVER] Client Connected #{_client.id}"
server.onDisconnect = (_client) ->
  log.info "[SERVER] Client Disconnected #{_client.id}"

############ Preload nodes and cables to local DB #############
start = performance()
LocalDatabase.updateNodes(database)
#LocalDatabase.updateCables(database)

################## Check if data is loaded ######################
runner = ->
  if LocalDatabase.nodesLoaded #and LocalDatabase.nodesLoaded

    log.info "Data loaded in #{((performance() - start) / 1000).toFixed(2)} Seconds"

    ############### Load data ####################################

    nodeList = LocalDatabase.table("nodes")
    cableList = LocalDatabase.table("cables")


    ############ Testing of Traffic Engine #######################

    te = new Macro.TrafficEngine(cableList)
    te.updateLoad()



    ############ Testing of pathfinder ############################
    """
    start = nodeList.findOne({id: 17418}).node
    end = nodeList.findOne({id: 17464}).node

    solution = Micro.Pathfinder.bStar(start, end)
    Micro.Pathfinder.printSolution(solution)
    """







    #console.log (keys = (k for k, v of cableList when typeof v is 'function'))

  else
    setTimeout(runner, 100)

runner()