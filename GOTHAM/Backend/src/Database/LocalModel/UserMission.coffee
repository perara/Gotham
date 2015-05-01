GothamObject = require './GothamObject.coffee'

###*
# UserMission Model, Contains all Missions started by a user
# @class UserMission
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class UserMission extends GothamObject

  constructor: (model) ->
    super(model)

  ###*
  # Get the User object associated with this  UserMission
  # @method getUser
  # @return {User}
  ###
  getUser: ->
    if not @User
      db_user = Gotham.LocalDatabase.table("User")
      @User = db_user.findOne({id: @user})
    return @User

  ###*
  # Get the Mission object associated with this UserMission
  # @method getMission
  # @return {Mission}
  ###
  getMission: ->
    if not @Mission
      db_mission = Gotham.LocalDatabase.table("Mission")
      @Mission = db_mission.findOne({id: @mission})
    return @Mission

  ###*
  # Get all associated UserMissionRequirements associated with this UserMission m2m
  # @method getUserMissionRequirements
  # @return {UserMissionRequirements}
  ###
  getUserMissionRequirements: ->
    if not @UserMissionRequirements
      db_userMissionRequirement = Gotham.LocalDatabase.table("UserMissionRequirement")
      @UserMissionRequirements = []
      for userMissionRequirement in db_userMissionRequirement.find({user_mission: @id})
        @UserMissionRequirements.push userMissionRequirement
    return @UserMissionRequirements

  ###*
  # Get all associated Requirements for this UserMission
  # @method getMissionRequirements
  # @return {MissionRequirement[]} Mission Requirements
  ###
  getMissionRequirements: ->
    if not @MissionRequirements
      db_missionRequirement = Gotham.LocalDatabase.table("MissionRequirement")
      @MissionRequirements = []
      for missionRequirement in db_missionRequirement.find({mission: @mission})
        @MissionRequirements.push missionRequirement
    return @MissionRequirements



###*
# The id of the user_mission
# @property {Integer} id
###
###*
# The user of the user_mission
# @property {Integer} user
###
###*
# The mission of the user_mission
# @property {Integer} mission
###



module.exports = UserMission

