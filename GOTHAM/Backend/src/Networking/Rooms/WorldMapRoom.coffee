Room = require './Room.coffee'




class WorldMapRoom extends Room


  define: ->
    that = @
    @AddEvent "GetNodes", (data) ->
      client = @
      that.log.info "[WMRoom] GetNodes called" + data


      db_node = Gotham.LocalDatabase.table("Node")

      # Fetch all cables, then eager load cables
      nodes = db_node.find().map (item) ->
        item.getCables()
        return item
      client.emit 'GetNodes', nodes

    @AddEvent "GetCables", (data) ->
      that.log.info "[WMRoom] GetCables called" + data

      db_cable = Gotham.LocalDatabase.table("Cable")

      cables = db_cable.find().map (cable) ->
        cable.getCablePart()
        cable.getCableType()
        cable.getNodes()
        return cable

      client.emit 'GetCables', cables




module.exports = WorldMapRoom



