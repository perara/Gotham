GothamObject = require './GothamObject.coffee'

###*
# Cable model for Local Database
# @class Cable
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Cable extends GothamObject

  constructor: (model) ->
    super(model)

  ###*
  # Get CableType of this Cable
  # @method getCableType
  # @return {CableType}
  ###
  getCableType: ->
    if not @_cableType
      db_cableType = Gotham.LocalDatabase.table("CableType")
      @_cableType = db_cableType.findOne({id: @type})

    return @_cableType

  ###*
  # Get CableParts of this cable
  # @method getCableParts
  # @return {CablePart[]}
  ###
  getCableParts: ->
    if not @_cableParts
      db_cablePart = Gotham.LocalDatabase.table("CablePart")
      @_cableParts = db_cablePart.find({cable: @id})
    return @_cableParts

  ###*
  # Get all associated nodes for this Cable
  # @method getNodes
  # @return {Node[]}
  ###
  getNodes: ->
    if not @_nodes
      db_node = Gotham.LocalDatabase.table("Node")
      db_nodeCable = Gotham.LocalDatabase.table("NodeCable")
      @_nodes = []
      for nodeCable in db_nodeCable.find({cable: @id})
        @_nodes.push  db_node.findOne({id: nodeCable.node})
    return @_nodes


  ###*
  # The Identifier of this Cable
  # @property {Integer} id
  ###
  ###*
  # The priority for this Cable
  # @property {Integer} priority
  ###
  ###*
  # The capacity for this Cable
  # @property {Integer} capacity
  ###
  ###*
  # The Associated CableType id for this cable
  # @property {CableType} type
  ###
  ###*
  # The distance (Length) for this cable
  # @property {Integer} distance
  ###
  ###*
  # The Name of the cable
  # @property {String} name
  ###
  ###*
  # The Year this cable was created
  # @property {Integer} year
  ###






module.exports = Cable