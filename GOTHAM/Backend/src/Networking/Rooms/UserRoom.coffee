Room = require './Room.coffee'




class UserRoom extends Room

  define: ->
    that = @

    @AddEvent "GetUser", (data) ->
      client = that.GetClient(@id)

      that.Database.Model.User.find(
        where: client.GetUser().id
        include:
          [
            {
              model: that.Database.Model.Identity
              include:
                [
                  {
                    model: that.Database.Model.Network
                    include:
                      [
                        {
                          model: that.Database.Model.Node
                        },
                        {
                          model: that.Database.Model.Host
                          include:
                            [
                              model: that.Database.Model.Filesystem
                            ]
                        }
                      ]
                  }
                ]
            }
          ]
      ).then (user) ->
        client.Socket.emit 'GetUser', user














module.exports = UserRoom



