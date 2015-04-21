Room = require './Room.coffee'




class WorldMapRoom extends Room


  define: ->
    that = @
    @AddEvent "GetNodes", (data) ->
      client = @
      that.log.info "[WMRoom] GetNodes called" + data

      that.Database.Model.Node.all(
        {
          include: [
            {
              model: that.Database.Model.Cable
              attributes: ['id']
            }
          ]
        }
      ).then (nodes)->
        client.emit 'GetNodes', nodes

    @AddEvent "GetCables", (data) ->
      client = @
      that.log.info "[WMRoom] GetCables called" + data


      # Nodes, CableType
      that.Database.Model.Cable.all(
        {
          include: [
            {
              model: that.Database.Model.CablePart
            }
            {
              model: that.Database.Model.CableType
            }
            {
              model: that.Database.Model.Node
              attributes: ['id']
            }
          ]
        }
      ).then (cables) ->

        cables.map (cable) ->
          cable.CableParts.map (part) ->
            return 


        client.emit 'GetCables', JSON.stringify(cables)




module.exports = WorldMapRoom



