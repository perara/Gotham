cfg     =     require './config.json'
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'
Traffic = require './Objects/Traffic/Traffic.coffee'
LocalDatabase = require './Database/LocalDatabase.coffee'
ConsistencyFixer = require './RepairTools/ConsistencyFixer.coffee'
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

database.Model.Node.all(
  include: [
    {
      model: database.Model.Cable
      include: [database.Model.Node]
    }
  ]
).then (nodes)->

  ############ Preload nodes and cables to local DB #############

  nodeList = LocalDatabase.table("nodes")

  for node in nodes
    nodeList.insert {id: node.id, node: node}

  ############ Consistency check of Sea nodes ###################

  #new ConsistencyFixer()

  ############ Testing of pathfinder ############################
  start = nodeList.findOne({id: 17418}).node
  end = nodeList.findOne({id: 17464}).node

  solution = Traffic.Pathfinder.bStar(start, end)
  Traffic.Pathfinder.printSolution(solution)


"""
  start = new Date().getTime()
  console.log new Date().getTime() - start


  start = new Date().getTime()
  console.log new Date().getTime() - start
"""
"""
server = new SocketServer 4443, true
server.RegisterRoom new (require './Networking/Rooms/UserRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
server.Start()
server.onConnect = (_client) ->
  # Create a new client object
  client = @Client(_client)

  _client.emit 'test'
  _client.on 'clientsay', ->
    console.log ":O"


client = require('socket.io-client')('http://localhost:4443');
client.on 'connect', ->
  client.on 'test', ->
    console.log "Run client say"
    client.emit 'clientsay'
"""

"""
server = new SocketServer 8080, true
server.RegisterRoom new (require './Networking/Rooms/UserRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()

server.onConnect = (client) ->
  server.AddToRooms client

server.Start()




server.Socket().on 'connection', (client) ->
  server.AddToRooms client



database = new Database()

start = new Date().getTime()
"""


"""database.Model().Cable.findAll
  #where:
  #  year: 1999
  include: model: database.Model().CableType
.then (cables) ->
  end = new Date().getTime() - start

  console.log cables.length

  console.log end + "ms"
"""






