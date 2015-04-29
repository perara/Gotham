GothamObject = require './GothamObject.coffee'

###*
# MissionRequirement Model, A Requirement is closely bound to the Mission Model
# @class MissionRequirement
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class MissionRequirement extends GothamObject

  constructor: (model) ->
    super(model)


###*
# The id of the mission_requirement
# @property {Integer} id
###
###*
# The mission of the mission_requirement
# @property {Integer} mission
###
###*
# The requirement of the mission_requirement
# @property {String} requirement
###
###*
# The default of the mission_requirement
# @property {String} default
###
###*
# The expected of the mission_requirement
# @property {String} expected
###
###*
# The emit of the mission_requirement
# @property {String} emit
###
###*
# The emit_value of the mission_requirement
# @property {String} emit_value
###
###*
# The emit_input of the mission_requirement
# @property {String} emit_input
###
###*
# The emit_behaviour of the mission_requirement
# @property {String} emit_behaviour
###


module.exports = MissionRequirement

