WebSocket = require 'ws'


class IPViking

  constructor: ->


  Connect: ->
    ws = new WebSocket 'ws://64.19.78.244:443/'
    ws.on 'message', (message) ->
      for key, client of Gotham.SocketServer.GetClients()
        # Relays IPViking to all clients
        client.Socket.emit 'IPViking_Attack', message




module.exports = IPViking