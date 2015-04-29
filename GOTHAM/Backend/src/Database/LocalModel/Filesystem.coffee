GothamObject = require './GothamObject.coffee'

###*
# Filesystem Model, Contains the data for the filesystem
# @class Filesystem
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Filesystem extends GothamObject

  constructor: (model) ->
    super(model)


###*
# The identifier of the filesystem
# @property {Integer} id
###
###*
# The data of the filesystem (JSON)
# @property {String} data
###

module.exports = Filesystem