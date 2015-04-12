'use strict'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
co  = require 'co'
log = require('log4js').getLogger("Test_Networking")


SocketServer = require '../Networking/SocketServer.coffee'
Database = require '../Database/Database.coffee'




suite 'Networking Tests', ->
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


  suiteTeardown ->
    @server.Stop()
    @client.disconnect()



  test 'Connection OK', (done)->
    done()



  test 'Check Room Callbacks', (done) ->
    @timeout(5500)

    login =
      username: "per"
      password: "per"

    # Emit stuff
    @client.emit('Login', login)
    @client.emit('GetNodes', "")
    @client.emit('GetHost', "")
    @client.emit('GetCables', "")
    @client.emit('Logout', "")
    @client.emit('Terminate', "")

    # Callbacks
    @client.on 'Login', (json) ->
      data = JSON.parse json
      expect(data.username).to.be.equal("per")
      expect(data).to.be.a('object')
    @client.on 'GetNodes', (data) ->
      expect(data).to.be.a('String')
      expect(data.length).to.be.greaterThan(2000)
    @client.on 'GetHost', (data) ->
      console.log data
      expect(data).to.be.a('String')

    @client.on 'Logout', (data) ->
      expect(data).to.be.equal("OK")
      expect(data).to.be.a('String')

    @client.on 'Terminate', (data) ->
      @disconnect()


    setTimeout(done,5000)

    @client.on 'terminate', (data) ->































