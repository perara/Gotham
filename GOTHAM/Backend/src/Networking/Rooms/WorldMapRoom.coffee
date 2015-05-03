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
        return {
          bandwidth: item.bandwidth
          Country: item.getCountry()
          id: item.id
          lat: item.lat
          lng: item.lng
          name: item.name
          priority: item.priority
          tier: item.tier
          Network:
            submask: item.getNetwork().submask
            internal_ip_v4: item.getNetwork().internal_ip_v4
            external_ip_v4: item.getNetwork().external_ip_v4
            dns: item.getNetwork().dns
            lat: item.getNetwork().lat
            lng: item.getNetwork().lng
          Cables: item.getCables().map (i) ->
            return {
              capacity: i.capacity
              distance: i.distance
              id: i.id
              name: i.name
              priority: i.priority
              type: i.type
            }
        }

      client.emit 'GetNodes', nodes


    ###*
    # Emitter for getting cables (Defined as class, but is in reality a method inside WorldMapRoom)
    # @class Emitter_GetCables
    # @submodule Backend.Emitters
    ###
    @addEvent "GetCables", (data) ->
      client = @
      that.log.info "[WMRoom] GetCables called" + data

      db_cable = Gotham.LocalDatabase.table("Cable")

      cables = db_cable.find().map (cable) ->
        return {
          id: cable.id
          distance: cable.distance
          name: cable.name
          year: cable.year
          priority: cable.priority
          capacity: cable.capacity
          CableParts: cable.getCableParts()
          CableType: cable.getCableType()
          Nodes: cable.getNodes().map (i) ->
            return i.id
        }

      client.emit 'GetCables', cables




module.exports = WorldMapRoom



