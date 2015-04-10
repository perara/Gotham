logger = require('log4js').getLogger("Room")




class Room

  constructor: ->
    @_events = {}
    @define()

  define: ->
    throw new Error "This function should be overrided"

  AddEvent: (eventName, callback) ->
    @_events[eventName] = callback


  Add: (client)->
    for eventName, callback of @_events
      logger.info "[ROOM] Adding \"#{eventName}\" to #{client.id} "
      client.on eventName, callback





module.exports = Room