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

      that.Database.Model.UserMission.findOne(
        where:
          mission: mission.id
          user: client.GetUser().id
      ).then (record) ->

        # Return with error if record exists. Means user has already started Mission
        if record
          client.Socket.emit 'ERROR', {
            type: "ERROR_MISSION_ONGOING"
            message: "You cannot start the same mission twice!"
          } # TODO Multilangual
          return

        # Start the Mission for the User
        # Create a UserMission entity
        that.Database.Model.UserMission.create(
          user: client.GetUser().id
          mission: mission.id
        ).then (userMission) ->

          # Find Mission Entity from local db
          mission = Gotham.LocalDatabase.table("missions").find({id : userMission.mission})[0].mission

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

      missions = []
      _ongoing = []
      _available = []
      promises = []

      # Fetch all available missions
      promises.push that.Database.Model.Mission.all(include: [{ all: true, nested:true}]).then (_missions) ->

        # Create a mission object and push to missions array
        for missionData in _missions
          _available.push that.CreateMissionObject missionData, null


      # Fetch all ongoing missions
      promises.push that.Database.Model.UserMission.all(
        where: user: 1
        include: [{ all: true, nested:true}]
      ).then (userMissions) ->

        # Create ongoing missions
        for userMission in userMissions
          mission = that.CreateMissionObject userMission.Mission, userMission.UserMissionRequirements

          # Push the ongoing mission to the array
          _ongoing.push mission


      When.all(promises).then () ->


        # First add ongoing missions to the missions array
        for ongoing in _ongoing
          missions.push ongoing

        # Secondly add all available missions that are not ongoing
        for available in _available

          # Dont add available t othe mission array if its already ongoing
          add = true
          for mission in missions
            if mission.id == available.id
              add = false

          # Add available to array
          if add
            missions.push available

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

  MakeMission = (missionID, userID) ->

    getRandomNetwork = ->
      hosts = Gotham.LocalDatabase.table("hosts").data
      return hosts[Math.floor(Math.random() * hosts.length)].host.dataValues

    # Load missions and requirements
    missions = Gotham.LocalDatabase.table("missions")
    mission =  missions.find(id: missionID)[0]
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

        #### If command is none ####
          when "none"
            console.log key
            commands[command][key] = {}

            if propDef
              commands[command][key] = propDef


    console.log commands
    # Get all requirements
    for req in requirements
      req = req.dataValues


      emit_value = JSON.parse(req.emit_value)
      emit_input = JSON.parse(req.emit_input)
      expected = JSON.parse(req.expected)


module.exports = MissionRoom