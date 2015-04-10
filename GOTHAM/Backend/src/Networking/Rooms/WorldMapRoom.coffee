Room = require './Room.coffee'




class WorldMapRoom extends Room


  define: ->
    that = @
    @AddEvent "GetNodes", (data) ->
      client = @
      that.log.info "[WMRoom] GetNodes called" + data

      that.Database.Model.Node.all().then (nodes)->
        client.emit 'GetNodes', JSON.stringify(nodes)



module.exports = WorldMapRoom



