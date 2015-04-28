
GothamObject = require './GothamObject.coffee'

class UserMissionRequirement extends GothamObject

  constructor: (model) ->
    super(model)

  getUserMission: ->
    if not @UserMission
      db_userMission = Gotham.LocalDatabase.table("UserMission")
      @UserMission = db_userMission.findOne({id: @user_mission})
    return @UserMission

  getMissionRequirement: ->
    if not @MissionRequirement
      db_missionRequirement = Gotham.LocalDatabase.table("MissionRequirement")
      @MissionRequirement = db_missionRequirement.findOne({id: @mission_requirement})
    return @MissionRequirement





module.exports = UserMissionRequirement

