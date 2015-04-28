GothamObject = require './GothamObject.coffee'

class Network extends GothamObject

  constructor: (model) ->
    super(model)

  getIdentity: ->
    if not @Identity
      db_identity = Gotham.LocalDatabase.table("Identity")
      @Identity = db_identity.findOne({id: @identity})
    return @Identity

  getNode: ->
    if not @Node
      db_node = Gotham.LocalDatabase.table("Node")
      @Node = db_node.findOne({id: @node})
    return @Node

  getHosts: ->
    if not @Hosts
      db_host = Gotham.LocalDatabase.table("Host")
      @Hosts = db_host.find({network: @id})

    return @Hosts




module.exports = Network