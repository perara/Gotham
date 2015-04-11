io      =     require 'socket.io'
http    =     require 'http'
log = require('log4js').getLogger("SocketIO")

Client = require './Client.coffee'
StringTools = require '../Tools/StringTools.coffee'

class SocketServer

  @Client = Client

  constructor: (port, debug)->
    @_port = port
    @_debug = debug
    @_server = null
    @_socket = null
    @clients = {}

    @onConnect = -> throw new Error "Should be overriden"
    @onDisconnect = -> throw new Error "Should be overriden"


    @_rooms = []

  Start: ->
    @_CreateServer();
    @_StartServer();

  Stop: ->
    @_socket.close()

  SetDatabase: (database) ->
    @_database = database

  GetDatabase: ->
    return @_database

  RegisterRoom: (room) ->
    # Sets the database
    room.SetDatabase @GetDatabase()
    room.SetSocketServer @
    log.info "[SOCKET]: Registering room #{room.constructor.name}"
    @_rooms.push room

  AddToRooms: (client) ->
    log.info "[SOCKET]: Adding Client #{client.id} to rooms"
    for room in @_rooms
      room.Add client

  Socket: () ->
    return @_socket

  AddClient: (client) ->
    @clients[client.id] = client

  RemoveClient: (client) ->
    delete @clients[client.id]

  GetClient: (clientID) ->
    return @clients[clientID]



  _CreateServer: ->
    that = @
    @_server = http.createServer (request, response) ->
      response.writeHead(200,{ 'Content-Type': 'text/html' });
      response.end '<h1>Gotham Backend</h1>'

  _OverrideEmitter: (_socket)->

    emit = _socket.emit

    _socket.emit = ->
      log.info("[EMITTER] ", Array.prototype.slice.call(arguments));
      emit.apply _socket, arguments

    $emit = _socket.$emit
    _socket.$emit = ->
      log.info('[EMITTER] ',Array.prototype.slice.call(arguments));
      $emit.apply _socket, arguments




  _StartServer: ->
    that = @
    @_server.listen @_port
    @_socket = io.listen @_server
    @_OverrideEmitter @_socket

    @_socket.on 'connection', (client) ->

      # Create client item, add the client and add rtooms to the client
      clientData = new SocketServer.Client(client)
      that.AddClient clientData
      that.AddToRooms client

      # Run callback
      that.onConnect(client)

      # Disconnect Callback definition
      client.on 'disconnect', ->
        that.RemoveClient client
        that.onDisconnect(client)



module.exports = SocketServer



