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
    if not @CableType
      db_cableType = Gotham.LocalDatabase.table("CableType")
      @CableType = db_cableType.findOne({id: @type})
    return @CableType

  ###*
  # Get CableParts of this cable
  # @method getCableParts
  # @return {CablePart[]}
  ###
  getCableParts: ->
    if not @CableParts
      db_cablePart = Gotham.LocalDatabase.table("CablePart")
      @CableParts = db_cablePart.find({cable: @id})
      @CableParts.reverse()
    return @CableParts

  ###*
  # Get all associated nodes for this Cable
  # @method getNodes
  # @return {Node[]}
  ###
  getNodes: ->
    if not @Nodes
      db_node = Gotham.LocalDatabase.table("Node")
      db_nodeCable = Gotham.LocalDatabase.table("NodeCable")
      @Nodes = []
      for nodeCable in db_nodeCable.find({cable: @id})
        @Nodes.push  db_node.findOne({id: nodeCable.node})
    return @Nodes



  updateLoad: ->
    VARIATION = 5

    cableParts = @getCableParts()

    # Find Middle point between cableParts
    startPart = cableParts[0]
    endPart = cableParts[cableParts.length - 1]

    # Calculate the mid point
    midPoint =
      lat: (startPart.lat + endPart.lat) / 2
      lng: (startPart.lng + endPart.lng) / 2

    # Find closest part to the mid point
    closestPart = Gotham.Util.GeoTool.getClosest(midPoint, cableParts)

    # Calculating what time it is on the current latitude (in total minutes)
    minutes = ((closestPart.lng + 180) / 0.25)  + Gotham.World.Clock.getMinutes()

    # Static variable for converting degrees to minutes with 12 hour offset
    deltaMinute = ((2 * Math.PI) / 1440)

    # Calculates the load from a sinus curve peaking at 18:00
    loadValue = Math.sin(deltaMinute * minutes)

    # Uses variation and multiplication to make a fictional amount of bandwidth
    @load = ((loadValue) + VARIATION) / 10
    return @load



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