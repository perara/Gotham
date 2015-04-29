log = require('log4js').getLogger("Room")



###*
# WorldMapRoom, Hosts emitters for WorldMap events
# @class WorldMapRoom
# @module Backend
# @submodule Backend.Networking
###
class Room

  constructor: ->
    ###*
    # Log paramterer for rooms.
    # @param {Log4js} log
    ###
    @log = log

    ###*
    # List of available events for this room (Added by addEvent)
    # @param {Callback[]} _events
    ###
    @_events = {}

    ###*
    # Database variable
    # @param {Database} _database
    # @private
    ###
    ###*
    # Database varaible (Public)
    # @param {Database} Database
    ###
    @_database = @Database = null

    @define()

  ###*
  # Define method, This **MUST BE** overridden by all Rooms. This runs whenever the room in initialized
  # @method define
  ###
  define: ->
    throw new Error "This function should be overrided"

  ###*
  # Adda a event callback to the event list (Emit va socket)
  # @method addEvent
  # @param {String} eventName
  # @param {Callback} callback
  ###
  addEvent: (eventName, callback) ->
    @_events[eventName] = callback

  ###*
  # Sets the database object for this room
  # @method setDatabase
  # @param {Database} database
  ###
  setDatabase: (database) ->
    @_database = @Database = database

  ###*
  # Sets the socket server instance for this room
  # @method setSocketServer
  # @param {SocketServer} socketserver
  ###
  setSocketServer: (socketserver) ->
    @_socketServer = socketserver

  ###*
  # Get client by clientID
  # @method getClient
  # @param {String} clientID
  ###
  getClient: (clientID) ->
    return @_socketServer.clients[clientID]

  ###*
  # Removes client by object
  # @method removeClient
  # @param {Client} client
  ###
  removeClient: (client) ->
    delete @_socketServer.clients[client.id]

  ###*
  # Adds a client to the room, adding all available events
  # @method addClient
  # @param {Client} client
  ###
  addClient: (client)->
    for eventName, callback of @_events
      #log.info "[ROOM] Adding \"#{eventName}\" to #{client.id} "
      client.on eventName, callback





module.exports = Room