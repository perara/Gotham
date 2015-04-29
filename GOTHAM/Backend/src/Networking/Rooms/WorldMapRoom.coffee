Room = require './Room.coffee'



###*
# WorldMapRoom, Hosts emitters for WorldMap events
# @class WorldMapRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class WorldMapRoom extends Room


  define: ->
    that = @

    ###*
    # Emitter for getting nodes (Defined as class, but is in reality a method inside WorldMapRoom)
    # @class Emitter_GetNodes
    # @submodule Backend.Emitters
    ###
    @addEvent "GetNodes", (data) ->
      client = @
      that.log.info "[WMRoom] GetNodes called" + data


      db_node = Gotham.LocalDatabase.table("Node")

      # Fetch all cables, then eager load cables
      nodes = db_node.find().map (item) ->
        item.getCables()
        return item
      client.emit 'GetNodes', nodes


    ###*
    # Emitter for getting cables (Defined as class, but is in reality a method inside WorldMapRoom)
    # @class Emitter_GetCables
    # @submodule Backend.Emitters
    ###
    @addEvent "GetCables", (data) ->
      that.log.info "[WMRoom] GetCables called" + data

      db_cable = Gotham.LocalDatabase.table("Cable")

      cables = db_cable.find().map (cable) ->
        cable.getCablePart()
        cable.getCableType()
        cable.getNodes()
        return cable

      client.emit 'GetCables', cables




module.exports = WorldMapRoom



