Room = require './Room.coffee'

###*
# UserRoom, Room which contains emitter related to user events
# @class UserRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class UserRoom extends Room

  define: ->
    that = @


    ###*
    # Emitter for getting a user (Defined as class, but is in reality a method inside UserRoom)
    # @class Emitter_GetUser
    # @submodule Backend.Emitters
    ###
    @addEvent "GetUser", (data) ->
      client = that.getClient(@id)

      db_user = Gotham.LocalDatabase.table("User")
      user = db_user.findOne({id: client.getUser().id})
      # Eager Load stuff
      for identity in user.getIdentities()
        for network in identity.getNetworks()
          network.getNode()
          for host in network.getHosts()
            host.getFilesystem()

      client.Socket.emit 'GetUser', user














module.exports = UserRoom



