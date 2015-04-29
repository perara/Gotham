WebSocket = require 'ws'

###*
# IPViking is a attackmap with good traffic flow. FrOM TO location with Port and service information
# @class IPViking
# @module Backend
# @submodule Backend.World
###
class IPViking

  constructor: ->

  ###*
  # connect to the stream
  # @method connect
  ###
  connect: ->
    ws = new WebSocket 'ws://64.19.78.244:443/'
    ws.on 'message', (message) ->

      if parseInt(message.latitude) == 0 or parseInt(message.longitude) == 0 or parseInt(message.latitude2) == 0 or parseInt(message.longitude2) == 0
        return

      for key, client of Gotham.SocketServer.getClients()
        # Relays IPViking to all clients
        client.Socket.emit 'IPViking_Attack', message




module.exports = IPViking