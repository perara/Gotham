io      =     require 'socket.io'
http    =     require 'http'
log = require('log4js').getLogger("SocketIO")


StringTools = require '../Tools/StringTools.coffee'

class SocketServer

  constructor: (port, debug)->
    @_port = port
    @_debug = debug
    @_server = null
    @_socket = null

    @onConnect = ->
      console.log "wtf"

    @_rooms = []

  Start: ->
    @_CreateServer();
    @_StartServer();

  Stop: ->
    @_socket.close()

  RegisterRoom: (room) ->
    @_rooms.push room

  AddToRooms: (client) ->
    log.info "[SOCKET]: Adding Client #{client.id} to rooms"
    for room in @_rooms
      room.Add client

  Socket: () ->
    return @_socket


  _CreateServer: ->
    that = @
    @_server = http.createServer (request, response) ->
      response.writeHead(200,{ 'Content-Type': 'text/html' });
      response.end '<h1>Gotham Backend</h1>'


  _StartServer: ->
    that = @
    @_server.listen @_port
    @_socket = io.listen @_server
    @_socket.on 'connection', (client) ->
      that.onConnect(client)



module.exports = SocketServer



