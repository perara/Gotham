
GothamObject = require './GothamObject.coffee'

class UserMission extends GothamObject

  constructor: (model) ->
    super(model)


  getUser: ->
    if not @User
      db_user = Gotham.LocalDatabase.table("User")
      @User = db_user.findOne({id: @user})
    return @User

  getMission: ->
    if not @Mission
      db_mission = Gotham.LocalDatabase.table("Mission")
      @Mission = db_mission.findOne({id: @mission})
    return @Mission

  getUserMissionRequirements: ->
    if not @UserMissionRequirements
      db_userMissionRequirement = Gotham.LocalDatabase.table("UserMissionRequirement")
      @UserMissionRequirements = []
      for userMissionRequirement in db_userMissionRequirement.find({user_mission: @id})
        @UserMissionRequirements.push userMissionRequirement
    return @UserMissionRequirements




module.exports = UserMission

