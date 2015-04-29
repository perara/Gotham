GothamObject = require './GothamObject.coffee'

###*
# Mission Model contains data for the mission
# @class Mission
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Mission extends GothamObject

  constructor: (model) ->
    super(model)

  ###*
  # Get all MissionRequirements for this mission
  # @method getMissionRequirements
  # @return {MissionRequirement}
  ###
  getMissionRequirements: ->
    if not @MissionRequirements
      db_missionRequirements = Gotham.LocalDatabase.table("MissionRequirement")
      @MissionRequirements = db_missionRequirements.find({mission: @id})
    return @MissionRequirements

###*
# The id of the mission
# @property {Integer} id
###
###*
# The title of the mission
# @property {String} title
###
###*
# The description of the mission
# @property {String} description
###
###*
# The description_ext of the mission
# @property {String} description_ext
###
###*
# The required_xp of the mission
# @property {Integer} required_xp
###


module.exports = Mission

