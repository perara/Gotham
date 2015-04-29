EventSource = require('eventsource');

###*
# Cyberfeed attack map. Is a stream of infected hosts statistics.
# @class Cyberfeed
# @module Backend
# @submodule Backend.World
###
class Cyberfeed

  ###*
  # connect to the stream
  # @method connect
  ###
  connect: ->
    #http://globe.cyberfeed.net/events
    es = new EventSource('http://globe.cyberfeed.net/events');
    es.onmessage = (e) ->
      console.log(e.data)

    es.onerror = ->
      console.log('ERROR!')



module.exports = Cyberfeed