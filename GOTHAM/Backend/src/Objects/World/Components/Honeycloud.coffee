WebSocket = require('ws');

class HoneyCloud


  Connect: ->

    ws = new WebSocket('ws://map.honeynet.org/data/685/8m26_vt4/websocket', {
      protocolVersion: 8,
      origin: 'http://map.honeynet.org'
    });

    ws.on 'open', ->
      console.log('connected');

    ws.on 'message', (data, flags) ->
      if data == 'o' or data == 'h'
        return
      data = data.substring(1)

      json = JSON.parse(JSON.parse(data)[0])




module.exports = HoneyCloud