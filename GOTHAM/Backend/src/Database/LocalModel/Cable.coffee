GothamObject = require './GothamObject.coffee'

class Cable extends GothamObject

  constructor: (model) ->
    super(model)


  getCableType: ->
    if not @_cableType
      db_cableType = Gotham.LocalDatabase.table("CableType")
      @_cableType = db_cableType.findOne({id: @type})

    return @_cableType

  getCableParts: ->
    if not @_cableParts
      db_cablePart = Gotham.LocalDatabase.table("CablePart")
      @_cableParts = db_cablePart.find({cable: @id})
    return @_cableParts

  getNodes: ->
    if not @_nodes
      db_node = Gotham.LocalDatabase.table("Node")
      db_nodeCable = Gotham.LocalDatabase.table("NodeCable")
      @_nodes = []
      for nodeCable in db_nodeCable.find({cable: @id})
        @_nodes.push  db_node.findOne({id: nodeCable.node})
    return @_nodes




module.exports = Cable