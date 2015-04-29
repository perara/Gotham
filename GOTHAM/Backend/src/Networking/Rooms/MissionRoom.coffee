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
    # Emitter for mission Progression (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_ProgressMission
    # @submodule Backend.Emitters
    ###
    @addEvent "ProgressMission", (data) ->
      that.log.info "[MissionRoom] AcceptMission called"
      client = that.getClient(@id)

      that.Database.Model.UserMissionRequirement.findOne(
        where:
          id: data.userMissionRequirement
      ).then (record) ->

        # If the record does not exists ("Should" never happen, unless hacking occured)
        if not record
          client.Socket.emit 'ERROR', {
            type: "ERROR_MISSION_USER_REQUIREMENT_NOT_FOUND"
            message: "The mission requirement you attempted to update does not exist"
          } # TODO Multilangual
          return

        # Uppdate the current
        record.updateAttributes({
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
        user: client.GetUser().id
      })

      # If a result was found, return with error
      if userMission
        client.Socket.emit 'ERROR', {
          type: "ERROR_MISSION_ONGOING"
          message: "You cannot start the same mission twice!"
        } # TODO Multilangual
        return


      # Start the Mission for the User
      # Create a UserMission entity
      Gotham.LocalDatabase.Model.UserMission.create {
        user: client.GetUser().id
        mission: mission.id
      }, (mission) ->

        # Mission entry is now created
        client.Socket.emit 'AcceptMission', mission





    ###*
    # Emitter for AbandonMission (Defined as class, but is in reality a method inside MissionRoom)
    # @class Emitter_AbandonMission
    # @submodule Backend.Emitters
    ###
    @addEvent "AbandonMission", (mission) ->
      that.log.info "[MissionRoom] AbandonMission called"
      client = that.getClient(@id)

      that.Database.Model.UserMission.findOne(
        where:
          mission: mission.id
          user: client.GetUser().id
      ).then (record) ->

        if not record
          client.Socket.emit 'ERROR', {
            type: "ERROR_MISSION_NOT_ONGOING"
            message: "You cannot abandon a mission not currently ongoing!"
          } # TODO Multilangual
          return

        record.destroy().on 'success', (u) ->
          if u

            # Find Mission Entity from local db
            mission = Gotham.LocalDatabase.table("missions").find({id : record.mission})[0].mission

            client.Socket.emit 'AbandonMission', mission


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
      for _m in missions.ongoing
        _m.getMission()
        _m.getUserMissionRequirements()

      client.Socket.emit 'GetMission', missions

  # Create a Mission objece
  # @param missionData {Mission} THe mission data
  # @param userRequirement {UserMissionRequirement} Requirement for the user on this mission
  # @returns [MissionObject} a mission object
  CreateMissionObject: (missionData, userMissionRequirement) ->
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

  makeMission = (missionID, userID) ->

    getRandomNetwork = ->
      hosts = Gotham.LocalDatabase.table("Host").data
      return hosts[Math.floor(Math.random() * hosts.length)].host.dataValues

    # Load missions and requirements
    missions = Gotham.LocalDatabase.table("MissionRequirement")
    mission =  missions.find(id: missionID)[0]
    console.log mission
    requirements = mission.mission.dataValues.MissionRequirements

    # Generate user_mission object
    userMission = {}
    userMission.id = 0
    userMission.mission = missionID
    userMission.user = userID

    commands = {}

    # Get data from requirements and generate base for missions
    for req in requirements

      expected = JSON.parse(req.dataValues.expected)
      key = expected["key"]
      command = expected["command"]
      propDef = expected["prop"]
      prop = null

      # Connection table in database hopefully remove this
      missionReq = {}
      missionReq.user_mission = userMission
      missionReq.mission_requirement = req.id

      # Check if shit command exists
      if not commands[command] then commands[command] = {}

      # Check if shit key exists in shit command
      if not commands[command][key]

        switch command

        #### If command is network #####
          when "network"
            commands[command][key] = getRandomNetwork()

            if propDef
              prop = Gotham.Util.StringTools.Resolve(commands[command][key], propDef)

          ## If command is none ####
          when "none"
            console.log key
            commands[command][key] = {}

            if propDef
              commands[command][key] = propDef

    # Get all requirements
    for req in requirements
      req = req.dataValues


      emit_value = JSON.parse(req.emit_value)
      emit_input = JSON.parse(req.emit_input)
      expected = JSON.parse(req.expected)


module.exports = MissionRoom