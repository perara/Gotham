GothamObject = require './GothamObject.coffee'

###*
# Tier Model, Represents the tier of an Node
# @class Tier
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Tier extends GothamObject

  constructor: (model) ->
    super(model)


###*
# The id of the tier
# @property {Integer} id
###
###*
# The name of the tier
# @property {String} name
###

module.exports = Tier