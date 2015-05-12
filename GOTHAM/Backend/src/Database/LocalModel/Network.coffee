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
  # Generates a new network with random properties
  # @method generate
  # @return {Network} The new network instance
  # @static
  ###
  @generate: ->
    # TODO
    db_network = Gotham.LocalDatabase.table("Network")
    length = db_network.data.length
    rnd = Math.floor(Math.random() * length) + 1

    return db_network.data[rnd]


  ###*
  # Identity of the Network
  # @method getIdentity
  # @return {Identity}
  ###
  getIdentity: ->
    if not @Identity
      db_identity_network = Gotham.LocalDatabase.table("IdentityNetwork")
      @Identity = db_identity_network.findOne({network: @id}).getIdentity()
    return @Identity

  ###*
  # Node of the Network
  # @method getNode
  # @return {Node}
  ###
  getNode: ->
    if not @Node
      db_node = Gotham.LocalDatabase.table "Node"
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
  # Get DNS record for this network'S ip
  # @method getDNS
  # @return {DNS} The DNS record
  ###
  getDNS: ->
    if not @DNS
      db_dns = Gotham.LocalDatabase.table "DNS"
      @DNS = db_dns.findOne(ipv4: @external_ip_v4)
    return @DNS



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
# The mac of the network
# @property {String} mac
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