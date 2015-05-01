GothamObject = require './GothamObject.coffee'

###*
# Node Model of the Local Database
# @class Node
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Node extends GothamObject

  constructor: (model) ->
    super(model)


  ###*
  # Get All cables associated with this Node
  # @method getCables
  # @return {Cable[]}
  ###
  getCables: ->
    if not @Cables

      db_nodeCable = Gotham.LocalDatabase.table("NodeCable")
      db_cable = Gotham.LocalDatabase.table("Cable")
      @Cables = []
      for nodeCable in db_nodeCable.find({node: @id})
        @Cables.push db_cable.findOne({id: nodeCable.cable})

    return @Cables


  ###*
  # Get All siblings nodes to this Node
  # @method getSiblings
  # @return {Node[]}
  ###
  getSiblings: ->
    if not @Siblings
      @Siblings = {}
      for cable in @getCables()
        for node in cable.getNodes()
          if node.id == @id then continue
          @Siblings[node.id] = node

      # Convert Siblings map to array
      t = []
      for k, v of @Siblings
        t.push v
      @Siblings = t

    return @Siblings

  ###*
  # Get tier of this Node
  # @method getTier
  # @return {Tier}
  ###
  getTier: ->
    if not @Tier
      db_tier = Gotham.LocalDatabase.table("Tier")
      @Tier = db_tier.findOne({id: @tier})
    return @Tier

  ###*
  # Get Country for this Node
  # @method getCountry
  # @return {Country}
  ###
  getCountry: ->
    if not @Country
      db_country = Gotham.LocalDatabase.table("Country")
      @Country = db_country.findOne({id: @country})
    return @Country


  ###*
  # Updates load on node based of time
  # @method
  #
  ###
  updateLoad: ->
    sumCableLoad = 0
    cables = @getCables()

    for cable in cables
      sumCableLoad += cable.updateLoad()

    @load = sumCableLoad / cables.length




###*
# The id of the node
# @property {Integer} id
###
###*
# The name of the node
# @property {String} name
###
###*
# The countryCode of the node
# @property {String} countryCode
###
###*
# The tier of the node
# @property {Integer} tier
###
###*
# The priority of the node
# @property {Integer} priority
###
###*
# The bandwidth of the node
# @property {Double} bandwidth
###
###*
# The lat of the node
# @property {Double} lat
###
###*
# The lng of the node
# @property {Double} lng
###







module.exports = Node