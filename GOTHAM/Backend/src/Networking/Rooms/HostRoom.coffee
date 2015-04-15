Room = require './Room.coffee'




class HostRoom extends Room


  define: ->
    that = @

    @AddEvent "GetHost", (data) ->
      client = that.GetClient(@id)


      that.log.info "[HostRoom] GetHost called" + data

      that.Database.Model.Host.find(
        where: id: 2
        include: [
          that.Database.Model.Person,
          that.Database.Model.Filesystem,
          that.Database.Model.Node
        ]
      )
      .then((host) ->
        host.Filesystem.data = JSON.parse(host.Filesystem.data)
        ret =
          id: host.id
          node: host.Node
          person: host.Person
          filesystem: host.Filesystem
          ip: host.ip
          map: host.mac
          machineName: host.machine_name
          online: host.online


        client.Socket.emit 'GetHost', JSON.stringify(ret)

      )



module.exports = HostRoom