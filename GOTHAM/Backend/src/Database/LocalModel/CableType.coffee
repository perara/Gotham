GothamObject = require './GothamObject.coffee'

###*
# CableType Model, Represents type of an cable
# @class CableType
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class CableType extends GothamObject

  constructor: (model) ->
    super(model)

###*
# The identifier for this CableType
# @property {Integer} id
###
###*
# The name of the CableType
# @property {String} name
###

module.exports = CableType