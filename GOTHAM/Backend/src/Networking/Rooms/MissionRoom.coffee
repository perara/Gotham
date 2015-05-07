Room = require './Room.coffee'
When = require 'when'


###*
# MissionRoom, Mission emitters for Mission events
# @class MissionRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class MissionRoom extends Room


  define: ->
    that = @


    ###*
    # Emitter for mission Completion (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_CompleteMission
    # @submodule Backend.Emitters
    ###
    @addEvent "CompleteMission", (data) ->
      client = that.getClient(@id)
      db_user = Gotham.LocalDatabase.table "User"
      db_userMission = Gotham.LocalDatabase.table("UserMission")


      # Find the user mission
      userMission = db_userMission.findOne(id: data.id)
      _m = userMission.getMission()

      isComplete = true
      for userMissionRequirement in userMission.getUserMissionRequirements()
        if userMissionRequirement.current != userMissionRequirement.expected
          isComplete = false

      # Update the mission status to complete
      if isComplete
        # Set Completed to true
        userMission.update({
          complete: true
        })

        user = db_user.findOne(id: client.getUser().id)
        user.update({
          experience: user.experience + _m.experience_gain
          money: user.money + _m.money_gain
        })

        client.Socket.emit 'UpdatePlayerMoney', user.money
        client.Socket.emit 'UpdatePlayerExperience', user.experience



      else
        client.Socket.emit 'ERROR', {
          type: "ERROR_MISSION_NOT_COMPLETED"
          message: "The mission you attempted to complete is not completed yet!"
        } # TODO Multilangual

      client.Socket.emit 'CompleteMission', _m


    ###*
    # Emitter for mission Progression (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_ProgressMission
    # @submodule Backend.Emitters
    ###
    @addEvent "ProgressMission", (data) ->
      that.log.info "[MissionRoom] AcceptMission called"
      client = that.getClient(@id)

      db_userMissionRequirement = Gotham.LocalDatabase.table("UserMissionRequirement")

      userMissionRequirement = db_userMissionRequirement.findOne(id: data.userMissionRequirement)

      # If the record does not exists ("Should" never happen, unless hacking occured)
      if not userMissionRequirement
        client.Socket.emit 'ERROR', {
          type: "ERROR_MISSION_USER_REQUIREMENT_NOT_FOUND"
          message: "The mission requirement you attempted to update does not exist"
        } # TODO Multilangual
        return

      userMissionRequirement.update({
        current: data.current
      })

    ###*
    # Emitter for AcceptMission (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_AcceptMission
    # @submodule Backend.Emitters
    ###
    @addEvent "AcceptMission", (mission) ->
      that.log.info "[MissionRoom] AcceptMission called"
      client = that.getClient(@id)

      db_userMission = Gotham.LocalDatabase.table("UserMission")

      # Look for existsing user mission entry
      userMission = db_userMission.findOne({
        mission: mission.id
        user: client.getUser().id
      })

      # If a result was found, return with error
      if userMission and userMission.complete == false
        client.Socket.emit 'ERROR', {
          type: "ERROR_MISSION_ONGOING"
          message: "You cannot start the same mission twice!"
        } # TODO Multilangual
        return


      # Create Mission
      that.generateUserMission(client.getUser().id, mission.id, (userMission) ->
        userMission.getUserMissionRequirements()
        userMission.getMissionRequirements()
        userMission.getMission()
        client.Socket.emit 'AcceptMission', userMission
      )


    ###*
    # Emitter for AbandonMission (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_AbandonMission
    # @submodule Backend.Emitters
    ###
    @addEvent "AbandonMission", (mission) ->
      that.log.info "[MissionRoom] AbandonMission called"
      client = that.getClient(@id)

      db_userMission = Gotham.LocalDatabase.table 'UserMission'
      db_mission = Gotham.LocalDatabase.table 'Mission'

      # Fetch the user mission
      userMission = db_userMission.findOne({
        id: mission.id
      })

      # Fetch the user mission requirements
      userMissionRequirements = userMission.getUserMissionRequirements()


      # Delete all userMission requirements, Deletes userMission when this is done
      deleteCount = 0
      for userMissionRequirement in userMissionRequirements
        userMissionRequirement.delete ->
          deleteCount++
          if deleteCount >= userMissionRequirements.length
            userMission.delete(->)

            # Emit back empty mission
            _m = db_mission.findOne(id: userMission.mission)
            _m.getMissionRequirements()
            client.Socket.emit 'AbandonMission', _m



    ###*
    # Emitter for GetMission (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_GetMission
    # @submodule Backend.Emitters
    ###
    @addEvent "GetMission", (data) ->
      that.log.info "[MissionRoom] GetMission called" + data
      client = that.getClient(@id)

      missions =
        ongoing: []
        available: []


      db_mission = Gotham.LocalDatabase.table("Mission")
      db_userMission = Gotham.LocalDatabase.table("UserMission")

      # Fetch Available Missions
      missions.available = db_mission.find()
      for _m in missions.available
        _m.getMissionRequirements()


      # Fetch Ongoing Missions
      missions.ongoing = db_userMission.find({
        user: client.getUser().id
      })

      missions.ongoing = missions.ongoing.filter (i) ->
        if i.complete
          return false
        return true




      for _m in missions.ongoing
        _m.getMission()
        _m.getUserMissionRequirements()


      # Strip away mission in available list that are currently ongoing
      missions.available = missions.available.filter (item) ->
        for _m in missions.ongoing
          if item.id == _m.Mission.id
            return 0
        return 1


      client.Socket.emit 'GetMission', missions

  # Create a Mission object
  # @method createMissionObject
  # @param missionData {Mission} THe mission data
  # @param userRequirement {UserMissionRequirement} Requirement for the user on this mission
  # @returns [MissionObject} a mission object
  createMissionObject: (missionData, userMissionRequirement) ->
    userMissionRequirement = if not userMissionRequirement then null else userMissionRequirement

    # Create general mission data
    mission =
      id: missionData.id
      title: missionData.title
      description: missionData.description
      description_ext: missionData.description_ext
      required_xp: missionData.required_xp
      MissionRequirements: missionData.MissionRequirements
      ongoing: false

    # If userMissionRequirement is set, means its an goingoing mission
    if userMissionRequirement
      mission.ongoing = true
      mission.UserMissionRequirements = userMissionRequirement

    return mission

  ###*
  # generrates a user mission (Specific) for a user
  # @method generateUserMission
  # @param {Integer} userId
  # @param {Integer} missionId
  # @return
  ###
  generateUserMission: (userId, missionId, _c) ->
    _c = if _c then _c else ->

    # Fetch required tables
    db_user = Gotham.LocalDatabase.table 'User'
    db_mission = Gotham.LocalDatabase.table 'Mission'

    mission = db_mission.findOne(id: missionId)

    if not mission
    # TODO Err - Mission does not exist
      return

    user = db_user.findOne(id: userId)

    if not user
    # TODO Err - User does not exist
      return

    parser = (v) ->
      v = v.replace("[", "").replace("]", "")
      split = v.split(",")
      index = split[1]
      split = split[0].split("|")
      type = split[0]
      value = split[1]
      return {
        index: index
        type: type
        property: value
      }

    # Create a initial data structure
    data = {}

    # Iterate through mission requirements
    # First iteration:
    # Generates data map with data to populate the mission requirements with
    for requirement in mission.getMissionRequirements()

      #Get all
      values =
        expected: requirement.expected
        emit_value: requirement.emit_value
        emit_input: requirement.emit_input

      for key, value of values
        parsedValue = parser(value)

        # Ignore processing of Constant values
        if parsedValue.type == "Constant"
          continue

        # Ensure that type exists in datamap
        if not data[parsedValue.type]
          data[parsedValue.type] = {}

        # Ensure that the index exists, if not create it and generate the data
        if not data[parsedValue.type][parsedValue.index]
          # Generate data
          data[parsedValue.type][parsedValue.index] = Gotham.LocalDatabase.Model[parsedValue.type].generate()


    # Iterate through mission requirements
    # Second iteration:
    # Generates mission-
    userMissionRequirements = []
    for requirement in mission.getMissionRequirements()

      # Create Template
      userMissionRequirement =
        user_mission: null
        mission_requirement: requirement.id
        emit_value: null
        emit_input: null
        current: requirement.default
        expected: null
      userMissionRequirements.push userMissionRequirement

      # Parse all parsable values
      req =
        expected: parser(requirement.expected)
        emit_value:  parser(requirement.emit_value)
        emit_input:  parser(requirement.emit_input)

      # Iterate through all parsed requirements
      for key, value of req

        # Parse Constant properties
        if value.type == "Constant"
          userMissionRequirement[key] = value.property

        # Parse Entity properties
        else
          object = data[value.type][value.index]
          userMissionRequirement[key] = Gotham.Util.StringTools.Resolve object, value.property

    # Done generation, Create Entities
    Gotham.LocalDatabase.Model.UserMission.create({user: userId, mission: missionId, complete: false}, (userMission) ->

      if userMission == null
        # TODO error out, most likely unique error
        return

      # Create all user mission requirements
      count = 0 # Counter to keep track of number of saved elements
      for userMissionRequirement in userMissionRequirements


        Gotham.LocalDatabase.Model.UserMissionRequirement.create({
            user_mission: userMission.id
            mission_requirement: userMissionRequirement.mission_requirement
            emit_value: userMissionRequirement.emit_value
            emit_input: userMissionRequirement.emit_input
            current: userMissionRequirement.current
            expected: userMissionRequirement.expected
          }, (entry) ->

          # Increment counter
          count++
          #  When last element is saved
          if count >= userMissionRequirements.length
            _c(userMission)

          if not entry
            # TODO error out. Some wrong shit happened (Unique?)
            return
        )

    )

module.exports = MissionRoom