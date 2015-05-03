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
class IdentityNetwork extends GothamObject

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
  # Get the associated network
  # @method getCable
  # @return {Cable}
  ###
  getNetwork: ->
    if not @Network
      db_network = Gotham.LocalDatabase.table("Network")
      @Network = db_network.findOne({id: @network})
    return @Network

  ###*
  # Get the associated identity
  # @method getCable
  # @return {Cable}
  ###
  getIdentity: ->
    if not @Identity
      db_identity = Gotham.LocalDatabase.table("Identity")
      @Identity = db_identity.findOne({id: @identity})
    return @Identity

###*
# The id of the identity_network
# @property {Integer} id
###
###*
# The node of the identity_network
# @property {Integer} node
###
###*
# The identity of the identity_network
# @property {Integer} identity
###
###*
# The network of the identity_network
# @property {Integer} network
###


module.exports = IdentityNetwork