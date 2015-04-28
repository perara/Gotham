EventSource = require('eventsource');

class Cyberfeed


  Connect: ->
    #http://globe.cyberfeed.net/events
    es = new EventSource('http://globe.cyberfeed.net/events');
    es.onmessage = (e) ->
      console.log(e.data)

    es.onerror = ->
      console.log('ERROR!')



module.exports = Cyberfeed