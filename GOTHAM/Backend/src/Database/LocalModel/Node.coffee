GothamObject = require './GothamObject.coffee'

class Node extends GothamObject

  constructor: (model) ->
    super(model)

  getCables: ->
    if not @Cables

      db_nodeCable = Gotham.LocalDatabase.table("NodeCable")
      db_cable = Gotham.LocalDatabase.table("Cable")
      @Cables = []
      for nodeCable in db_nodeCable.find({node: @id})
        @Cables.push db_cable.findOne({id: nodeCable.cable})

    return @Cables

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

  getTier: ->
    if not @Tier
      db_tier = Gotham.LocalDatabase.table("Tier")
      @Tier = db_tier.findOne({id: @tier})
    return @Tier

  getCountry: ->
    if not @Country
      db_country = Gotham.LocalDatabase.table("Country")
      @Country = db_country.findOne({id: @country})
    return @Country










module.exports = Node