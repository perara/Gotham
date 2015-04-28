Room = require './Room.coffee'
When = require 'when'



class MissionRoom extends Room


  define: ->
    that = @



    # Whenever a requirement has progressed
    # Data structure is the following:
    # {
    #   userMissionRequirement: id
    #   current: currentVal
    # }
    #
    @AddEvent "ProgressMission", (data) ->
      that.log.info "[MissionRoom] AcceptMission called"
      client = that.GetClient(@id)

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





    @AddEvent "AcceptMission", (mission) ->
      that.log.info "[MissionRoom] AcceptMission called"
      client = that.GetClient(@id)

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






    @AddEvent "AbandonMission", (mission) ->
      that.log.info "[MissionRoom] AbandonMission called"
      client = that.GetClient(@id)

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



    @AddEvent "GetMission", (data) ->
      that.log.info "[MissionRoom] GetMission called" + data
      client = that.GetClient(@id)

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
        user: client.GetUser().id
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




module.exports = MissionRoom