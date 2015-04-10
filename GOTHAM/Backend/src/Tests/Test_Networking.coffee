'use strict'
io      =     require 'socket.io'
SocketServer = require '../Networking/SocketServer.coffee'

exports.NetworkTests =

  setUp: (callback) ->

    # Create a server
    @server = server = new SocketServer 4443, true
    server.RegisterRoom new (require '../Networking/Rooms/UserRoom.coffee')()
    server.RegisterRoom new (require '../Networking/Rooms/WorldMapRoom.coffee')()
    server.onConnect = (client) ->
      server.AddToRooms client
    server.Start()

    callback()
  tearDown: (callback) ->
    @server.Stop()
    callback()


  'Connection Tests': (test) ->
    @socket = require('socket.io-client')('http://localhost:4443');
    @socket.on 'connect', ->
      test.done()
    @socket.on 'disconnect', ->

































