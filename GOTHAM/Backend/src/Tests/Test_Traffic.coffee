chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
log = require('log4js').getLogger("Test_Traffic")

Traffic = require '../Objects/Traffic/Traffic.coffee'


suite 'Traffic Tests', ->

  suiteSetup ->

    database = new Database()
    server = new SocketServer 4443
    server.SetDatabase database
    server.RegisterRoom new (require '../Networking/Rooms/HostRoom.coffee')()
    server.RegisterRoom new (require '../Networking/Rooms/UserRoom.coffee')()
    server.RegisterRoom new (require '../Networking/Rooms/WorldMapRoom.coffee')()
    server.RegisterRoom new (require '../Networking/Rooms/GeneralRoom.coffee')()
    server.Start()
    server.onConnect = (_client) ->
      log.info "[SERVER] Adding client #{_client.id}"

      clientData = new SocketServer.Client(_client)
      server.AddClient clientData
      server.AddToRooms _client

    client = require('socket.io-client')('http://localhost:4443');
    client.on 'connect', ->
    @client = client
    @server = server

