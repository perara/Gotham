Room = require './Room.coffee'




class HostRoom extends Room

  userid = 1 #TODO remove later on


  define: ->
    that = @

    @AddEvent "GetHost", (data) ->
      client = that.GetClient(@id)


      that.log.info "[HostRoom] GetHost called" + data

      that.Database.Model.Host.find(
        where:
          owner: userid #client.user.id
        include: [that.Database.Model.Filesystem, that.Database.Model.Person]
      )
      .then((host) ->

        host.Filesystem.data = JSON.parse(host.Filesystem.data)

        client.Socket.emit 'GetHost', JSON.stringify(host)

      )



module.exports = HostRoom