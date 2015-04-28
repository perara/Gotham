Room = require './Room.coffee'




class GeneralRoom extends Room


  define: ->
    that = @

    @AddEvent "Login", (login) ->
      client = that.GetClient @id

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
        client.SetUser user
        client.Authenticate true
        client.Socket.emit 'Login', {"status": 200}
      else
        client.Socket.emit 'Login', {"status": 500}
        client.Socket.disconnect()


    @AddEvent "Logout", (data) ->
      that.log.info "[GeneralRoom] Logout called" + data
      client = that.GetClient @id
      that.RemoveClient client
      client.Socket.emit 'Logout', "OK"


    @AddEvent "Terminate", (data) ->
      that.log.info "[GeneralRoom] Terminate called" + data
      @emit 'Terminate', "OK"
      @disconnect()




module.exports = GeneralRoom