GothamObject = require './GothamObject.coffee'

class NodeCable extends GothamObject

  constructor: (model) ->
    super(model)


  getNode: ->
    if not @Node
      db_node = Gotham.LocalDatabase.table("Node")
      @Node = db_node.findOne({id: @node})
    return @Node

  getCable: ->
    if not @Cable
      db_cable = Gotham.LocalDatabase.table("Cable")
      @Cable = db_cable.findOne({id: @cable})
    return @Cable



module.exports = NodeCable