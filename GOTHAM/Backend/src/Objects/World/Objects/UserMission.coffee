
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
    if not @Misson
      db_mission = Gotham.LocalDatabase.table("Mission")
      @Misson = db_mission.findOne({id: @mission})
    return @Mission


module.exports = UserMission

