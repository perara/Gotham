Room = require './Room.coffee'




class HostRoom extends Room


  define: ->
    that = @

    @AddEvent "GetHost", (data) ->
      client = that.GetClient(@id)
      that.log.info "[HostRoom] Login called" + data

      that.Database.Model.Host.find(
        where:
          owner: client.user.id
        include: [that.Database.Model.Filesystem]
      )
      .then((host) ->

        host.Filesystem.data = JSON.parse(host.Filesystem.data)

        client.Socket.emit 'GetHost', JSON.stringify(host)

      )



module.exports = HostRoom