GothamObject = require './GothamObject.coffee'

class Identity extends GothamObject

  constructor: (model) ->
    super(model)

  getUser: ->
    if not @User
      db_user = Gotham.LocalDatabase.table("User")
      @User = db_user.findOne({id: @fk_user})
    return @User

  getNetworks: ->
    if not @Networks
      db_network = Gotham.LocalDatabase.table("Network")
      @Networks = db_network.find({identity: @id})
    return @Networks



module.exports = Identity