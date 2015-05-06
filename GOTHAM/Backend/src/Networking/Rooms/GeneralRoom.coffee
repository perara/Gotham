Room = require './Room.coffee'



###*
# GeneralRoom, Emitters which does not fit in any category but General
# @class GeneralRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class GeneralRoom extends Room


  define: ->
    that = @


    ###*
    # Emitter for Login (Defined as class, but is in reality a method inside GeneralRoom)
    # @class Emitter_Login
    # @submodule Backend.Emitters
    ###
    @addEvent "Login", (login) ->
      client = that.getClient @id

      that.log.info "[GeneralRoom] Login called: " + login
      that.log.info "---- Attempting to login with #{login.username}:#{login.password}"

      db_user = Gotham.LocalDatabase.table("User")

      # Check if credential is correct
      user = db_user.findOne({
        username: login.username
        password: login.password
      })

      # Send OK to frontend if ok else 500
      if user
        client.setUser user
        client.authenticate true
        client.Socket.emit 'Login', {"status": 200}
      else
        client.Socket.emit 'Login', {"status": 500}
        client.Socket.disconnect()

    ###*
    # Emitter for Reconnect login (Defined as class, but is in reality a method inside GeneralRoom)
    # @class Emitter_ReconnectLogin
    # @submodule Backend.Emitters
    ###
    @addEvent "ReconnectLogin", (login) ->
      client = that.getClient @id

      that.log.info "[GeneralRoom] ReconnectLogin called: " + login
      that.log.info "---- Attempting to ReconnectLogin with #{login.username}:#{login.password}"

      db_user = Gotham.LocalDatabase.table("User")

      # Check if credential is correct
      user = db_user.findOne({
        username: login.username
        password: login.password
      })

      # Send OK to frontend if ok else 500
      if user
        client.setUser user
        client.authenticate true
        client.Socket.emit 'ReconnectLogin', {"status": 200}
      else
        client.Socket.emit 'ReconnectLogin', {"status": 500}
        client.Socket.disconnect()


    ###*
    # Emitter for Logout (Defined as class, but is in reality a method inside GeneralRoom)
    # @class Emitter_Logout
    # @submodule Backend.Emitters
    ###
    @addEvent "Logout", (data) ->
      that.log.info "[GeneralRoom] Logout called" + data
      client = that.getClient @id
      that.removeClient client
      client.Socket.emit 'Logout', "OK"

    ###*
    # Emitter for Terminate (Defined as class, but is in reality a method inside GeneralRoom)
    # @class Emitter_Terminate
    # @submodule Backend.Emitters
    ###
    @addEvent "Terminate", (data) ->
      that.log.info "[GeneralRoom] Terminate called" + data
      @emit 'Terminate', "OK"
      @disconnect()




module.exports = GeneralRoom