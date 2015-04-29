GothamObject = require './GothamObject.coffee'

###*
# User Model, Contains data of registered users
# @class User
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class User extends GothamObject

  constructor: (model) ->
    super(model)

  ###*
  # Get All identities associated with this User
  # @method getIdentities
  # @return {Identity[]}
  ###
  getIdentities: ->
    if not @Identities
      db_identity = Gotham.LocalDatabase.table("Identity")
      @Identities = db_identity.find({fk_user: @id})
    return @Identities

  ###*
  # Get all associated user missions for this User
  # @method getUserMissions
  # @return {UserMission[]}
  ###
  getUserMissions: ->
    if not @UserMissions
      db_userMission = Gotham.LocalDatabase.table("UserMission")
      @UserMissions = db_userMission.find({user: @id})

  ###*
  # Get all missions for this user
  # @method getMissions
  # @return {Mission[]}
  ###
  getMissions: ->
    if not @Missions
      @Missions = []
      for userMission in @getUserMissions()
        @Missions.push userMission.getMission()
    return @Missions


###*
# The id of the user
# @property {Integer} id
###
###*
# The username of the user
# @property {String} username
###
###*
# The password of the user
# @property {String} password
###
###*
# The email of the user
# @property {String} email
###
###*
# The money of the user
# @property {Integer} money
###
###*
# The experience of the user
# @property {Integer} experience
###




module.exports = User