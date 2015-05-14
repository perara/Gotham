io      =     require 'socket.io'
http    =     require 'http'
log = require('log4js').getLogger("SocketIO")
Client = require './Client.coffee'
StringTools = require '../Tools/StringTools.coffee'


###*
# The SocketServer class is a wrapper for Socket.IO
# @class SocketServer
# @constructor
# @param {Integer} port
# @param {Boolean} debug
# @required
# @module Backend
# @submodule Backend.Networking
###
class SocketServer

  ###*
  # Static reference to the client Class
  # @property {Client} Client
  # @static
  ###
  @Client = Client

  constructor: (port, debug)->
    ###*
    # Port to listen to
    # @property {Integer} port
    ###
    @_port = port

    ###*
    # Debug flag
    # @property {Boolean} debug
    ###
    @_debug = debug

    ###*
    # Server Reference (Socket.IO)
    # @property {HTTP-Server} _server
    ###
    @_server = null

    ###*
    # The WebSocket Instance
    # @property {Socket.IO} _socket
    ###
    @_socket = null

    ###*
    # Reference to internal _socket propery
    # @property {Socket} Socket
    ###
    @socket = @_socket

    ###*
    # List of connected clients
    # @property {Client[]} clients
    ###
    @clients = {}

    ###*
    # Banlist for the server
    # @property {Array} banlist
    ###
    @banlist = []

    ###*
    # List of registered rooms for the SocketServer
    # @property {Room[]} _rooms
    ###
    @_rooms = []

    ###*
    # Callback for when a client connects to the server
    # @method onConnect
    ###
    @onConnect = -> throw new Error "Should be overriden"

    ###*
    # Callback for when a client disconnects from the server
    # @method onDisconnect
    ###
    @onDisconnect = -> throw new Error "Should be overriden"


  ###*
  # Starts the SocketServer
  # @method start
  ###
  start: ->
    @_createServer();
    @_startServer();

  ###*
  # Sets the banlist
  # @method setBanlist
  # @param {Array} banlist
  ###
  setBanlist: (banlist) ->
    @banlist = banlist

  ###*
  # Stops the SocketServer
  # @method stop
  ###
  stop: ->
    @_socket.close()

  ###*
  # Sets the database instance into the socket server
  # @method setDatabase
  # @param {Database} database
  ###
  setDatabase: (database) ->
    @_database = database


  ###*
  # Retrieces the database from the SocketServer instance
  # @method getDatabase
  # @return {Database} _database
  ###
  getDatabase: ->
    return @_database

  ###*
  # Registers a room to the SocketServer
  # @method registerRoom
  # @param {Room}room
  ###
  registerRoom: (room) ->
    # Sets the database
    room.setDatabase @getDatabase()
    room.setSocketServer @
    log.info "[SOCKET]: Registering room #{room.constructor.name}"
    @_rooms.push room

  ###*
  # Adds a client to ALL rooms
  # @method addToRooms
  # @param {Client} client
  ###
  addToRooms: (client) ->
    log.info "[SOCKET]: Adding Client #{client.id} to rooms"
    for room in @_rooms
      room.addClient client

  ###*
  # Add client to the client list
  # @method addClient
  # @param {Client} client
  ###
  addClient: (client) ->
    @clients[client.id] = client

  ###*
  # Removes a client from the SocketServer client list
  # @method removeClient
  # @param {Client} client
  ###
  removeClient: (client) ->
    delete @clients[client.id]

  ###*
  # Retrieves a client by ID
  # @method getClient
  # @param {String} clientID
  # @return {Client} client
  ###
  getClient: (clientID) ->
    return @clients[clientID]

  ###*
  # Retrieve all clients from SocketServer client registry
  # @method getClients
  # @return {Client[]} clients
  ###
  getClients: ->
    return @clients


  ###*
  # Creates the server instance (HTTP)
  # @method _createServer
  # @private
  ###
  _createServer: ->
    @_server = http.createServer (request, response) ->
      response.writeHead(200,{ 'Content-Type': 'text/html' });
      response.end '<h1>Gotham Backend</h1>'

  ###*
  # Overrides internal emitted events
  # @method _overrideEmitter
  # @private
  ###
  _overrideEmitter: (_socket)->

    emit = _socket.emit

    _socket.emit = ->
      log.info("[EMITTER] ", Array.prototype.slice.call(arguments));
      emit.apply _socket, arguments

    $emit = _socket.$emit
    _socket.$emit = ->
      log.info('[EMITTER] ',Array.prototype.slice.call(arguments));
      $emit.apply _socket, arguments



  ###*
  # Starts the socket server, Bound to 0.0.0.0
  # @method _startServer
  # @private
  ###
  _startServer: ->
    that = @
    @_server.listen @_port, "0.0.0.0"
    @_socket = io.listen @_server
    @_overrideEmitter @_socket

    @_socket.on 'connection', (client) ->

      # Disconnect the player if IP ban
      if client.handshake.address in that.banlist
        client.disconnect()

      # Create client item, add the client and add rtooms to the client
      clientData = new SocketServer.Client(client)
      that.addClient clientData
      that.addToRooms client

      # Run callback
      that.onConnect(client)

      # Disconnect Callback definition
      client.on 'disconnect', ->
        that.removeClient client
        that.onDisconnect(client)



module.exports = SocketServer



