cfg     =     require './config.json'
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'





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


"""database.Model().Cable.findAll
  #where:
  #  year: 1999
  include: model: database.Model().CableType
.then (cables) ->
  end = new Date().getTime() - start

  console.log cables.length

  console.log end + "ms"
"""






