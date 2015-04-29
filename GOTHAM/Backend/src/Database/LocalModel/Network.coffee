GothamObject = require './GothamObject.coffee'

###*
# Network Model, A Network is considered a router. It has a IP adress. I contains Many Hosts. Can be connected to a single Node
# @class Network
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Network extends GothamObject

  constructor: (model) ->
    super(model)

  ###*
  # Identity of the Network
  # @method getIdentity
  # @return {Identity}
  ###
  getIdentity: ->
    if not @Identity
      db_identity = Gotham.LocalDatabase.table("Identity")
      @Identity = db_identity.findOne({id: @identity})
    return @Identity

  ###*
  # Node of the Network
  # @method getNode
  # @return {Node}
  ###
  getNode: ->
    if not @Node
      db_node = Gotham.LocalDatabase.table("Node")
      @Node = db_node.findOne({id: @node})
    return @Node

  ###*
  # All Host Computers of this network
  # @method getHosts
  # @return {Host[]}
  ###
  getHosts: ->
    if not @Hosts
      db_host = Gotham.LocalDatabase.table("Host")
      @Hosts = db_host.find({network: @id})

    return @Hosts


###*
# The id of the network
# @property {Integer} id
###
###*
# The submask of the network
# @property {String} submask
###
###*
# The internal_ip_v4 of the network
# @property {String} internal_ip_v4
###
###*
# The external_ip_v4 of the network
# @property {String} external_ip_v4
###
###*
# The dns of the network
# @property {String} dns
###
###*
# The identity of the network
# @property {Integer} identity
###
###*
# The node of the network
# @property {Integer} node
###
###*
# The isLocal of the network
# @property {Boolean} isLocal
###
###*
# The lat of the network
# @property {Double} lat
###
###*
# The lng of the network
# @property {Double} lng
###

module.exports = Network