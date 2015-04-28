Room = require './Room.coffee'


class UserRoom extends Room

  define: ->
    that = @

    @AddEvent "GetUser", (data) ->
      client = that.GetClient(@id)

      db_user = Gotham.LocalDatabase.table("User")
      user = db_user.findOne({id: client.GetUser().id})
      # Eager Load stuff
      for identity in user.getIdentities()
        for network in identity.getNetworks()
          network.getNode()
          for host in network.getHosts()
            host.getFilesystem()

      client.Socket.emit 'GetUser', user














module.exports = UserRoom



