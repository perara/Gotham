GothamObject = require './GothamObject.coffee'

class User extends GothamObject

  constructor: (model) ->
    super(model)

  getIdentities: ->
    if not @Identities
      db_identity = Gotham.LocalDatabase.table("Identity")
      @Identities = db_identity.find({fk_user: @id})
    return @Identities


  getUserMissions: ->
    if not @UserMissions
      db_userMission = Gotham.LocalDatabase.table("UserMission")
      @UserMissions = db_userMission.find({user: @id})

  getMissions: ->
    if not @Missions
      @Missions = []
      for userMission in @getUserMissions()
        @Missions.push userMission.getMission()
    return @Missions






module.exports = User