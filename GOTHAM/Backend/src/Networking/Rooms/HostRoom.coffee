Room = require './Room.coffee'




class HostRoom extends Room


  define: ->
    that = @

    @AddEvent "GetHost", (data) ->
      that.log.info "[HostRoom] GetHost called" + data




module.exports = HostRoom