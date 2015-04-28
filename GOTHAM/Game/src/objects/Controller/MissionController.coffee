View = require '../View/MissionView.coffee'



class MissionController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name


  create: ->
    @setupMissions()
    @setupMissionEmitter()

    @hide()



  setupMissionEmitter: () ->
    that = @

    # Whenever a mission has been accepted (OK from Server)
    GothamGame.Network.Socket.on 'AcceptMission', (mission) ->
      GothamGame.MissionEngine.addMission mission
      that.View.removeAvailableMission mission
      that.View.addOngoingMission mission

    GothamGame.Network.Socket.on 'AbandonMission', (mission) ->
      GothamGame.MissionEngine.removeMission mission
      that.View.addAvailableMission mission
      that.View.removeOngoingMission mission


  setupMissions: ->

    db_mission = Gotham.Database.table("mission")
    missions = db_mission().get()

    for mission in missions

      # Create a mission object
      _m = GothamGame.MissionEngine.createMission mission

      # Set complete callback, emitting back to server when its done.
      _m.onComplete = (mission) ->
        console.log "#{mission._title} is complete!"


      # Whenever the mission has progress
      _m.onRequirementComplete = _m.onProgress = (requirement) ->

        # Emit progress to the server
        GothamGame.Network.Socket.emit 'ProgressMission', {
          userMissionRequirement: requirement.userMissionRequirementData.id
          current: requirement._current
        }

      # Update state of the mission (For example when mission is complete at load)
      _m.updateState()


      if mission.ongoing
        GothamGame.MissionEngine.addMission _m
        @View.addOngoingMission _m
      else
        @View.addAvailableMission _m


  show: ->
    @View.visible = true

  hide: ->
    @View.visible = false






module.exports = MissionController
