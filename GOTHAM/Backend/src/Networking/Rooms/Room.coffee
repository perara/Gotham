log = require('log4js').getLogger("Room")




class Room

  constructor: ->
    @log = log
    @_events = {}
    @_database = @Database = null
    @define()

  define: ->
    throw new Error "This function should be overrided"

  AddEvent: (eventName, callback) ->
    @_events[eventName] = callback

  SetDatabase: (database) ->
    @_database = @Database = database

  SetSocketServer: (socketserver) ->
    @_socketServer = socketserver

  GetClient: (clientID) ->
    return @_socketServer.clients[clientID]

  RemoveClient: (client) ->
    delete @_socketServer.clients[client.id]


  Add: (client)->
    for eventName, callback of @_events
      log.info "[ROOM] Adding \"#{eventName}\" to #{client.id} "
      client.on eventName, callback





module.exports = Room