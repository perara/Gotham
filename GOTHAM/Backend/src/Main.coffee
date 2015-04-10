cfg     =     require './config.json'
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'







database = new Database()
server = new SocketServer 4443
server.SetDatabase database
server.RegisterRoom new (require './Networking/Rooms/UserRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
server.RegisterRoom new (require './Networking/Rooms/GeneralRoom.coffee')()
server.Start()
server.onConnect = (_client) ->

  server.AddClient _client
  _clientInfo = new SocketServer.Client(_client)
  server.AddToRooms _client
  _client.Info = _clientInfo



client = require('socket.io-client')('http://localhost:4443');
client.on 'connect', ->
@client = client
@server = server



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






