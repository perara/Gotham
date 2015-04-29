GothamObject = require './GothamObject.coffee'

###*
# NodeCable Model, A Many to Many relation between Nodes and cables
# @class NodeCable
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class NodeCable extends GothamObject

  constructor: (model) ->
    super(model)


  ###*
  # Get associated node for this m2m Model
  # @method getNode
  # @return {Node}
  ###
  getNode: ->
    if not @Node
      db_node = Gotham.LocalDatabase.table("Node")
      @Node = db_node.findOne({id: @node})
    return @Node

  ###*
  # Get associated cable for this m2m Model
  # @method getCable
  # @return {Cable}
  ###
  getCable: ->
    if not @Cable
      db_cable = Gotham.LocalDatabase.table("Cable")
      @Cable = db_cable.findOne({id: @cable})
    return @Cable

###*
# The id of the node_cable
# @property {Integer} id
###
###*
# The node of the node_cable
# @property {Integer} node
###
###*
# The cable of the node_cable
# @property {Integer} cable
###

module.exports = NodeCable