Room = require './Room.coffee'




class WorldMapRoom extends Room


  define: ->
    that = @
    @AddEvent "GetNodes", (data) ->
      client = @
      that.log.info "[WMRoom] GetNodes called" + data

      that.Database.Model.Node.all().then (nodes)->
        client.emit 'GetNodes', JSON.stringify(nodes)

    @AddEvent "GetCables", (data) ->
      client = @
      that.log.info "[WMRoom] GetCables called" + data

      that.Database.Model.Cable.all(
        include:
          [
            """{
              model: that.Database.Model.Node
              attributes: ['id'] # Strip rest of node data only fetching id
              as: 'Nodes'
            }
            {
              model: that.Database.Model.CableType
              as: 'CableType'
            }"""
            {
              model: that.Database.Model.CablePart
            }
          ]

      ).then (cables)->
        client.emit 'GetCables', JSON.stringify(cables)


module.exports = WorldMapRoom



