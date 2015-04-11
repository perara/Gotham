Room = require './Room.coffee'




class GeneralRoom extends Room


  define: ->
    that = @

    @AddEvent "Login", (json) ->
      data = JSON.parse(json)
      client = that.GetClient @id

      that.log.info "[GeneralRoom] Login called: " + data

      that.log.info "---- Attempting to login with #{data.username}:#{data.password}"

      that.Database.Model.User.find(
        where:
          username: data.username
          password: data.password
        attributes: ['id', 'username', 'email', 'money', 'experience']

      ).then (user) ->

        if user
          client.user = user
          client.Authenticate true
          client.Socket.emit 'Login', JSON.stringify(user)
        else
          client.Socket.emit 'Login', "NOT OK"
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