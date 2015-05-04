View = require '../View/MissionView.coffee'


###*
# MissionController, This controller manages all Mission related data. This beeing the emitter from Backend and adding Missions to the view.
# @class MissionController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
###
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
      _mission = mission.Mission
      _mission.UserMissionRequirements = mission.UserMissionRequirements

      # Create a mission object
      _m = GothamGame.MissionEngine.createMission _mission
      _m.setOngoing true

      GothamGame.MissionEngine.addMission _m
      that.View.removeAvailableMission _m
      that.View.addOngoingMission _m

    GothamGame.Network.Socket.on 'AbandonMission', (mission) ->

      # Create a mission object
      _m = GothamGame.MissionEngine.createMission mission

      GothamGame.MissionEngine.removeMission _m
      that.View.addAvailableMission _m
      that.View.removeOngoingMission _m


  setupMissions: ->

    db_mission = Gotham.Database.table("mission")
    allMissions = db_mission.data[0]
    missions = []


    for _m in allMissions.available
      _m.ongoing = false
      missions.push _m



    for _m in allMissions.ongoing
      _m["Mission"]["UserMissionRequirements"] = _m["UserMissionRequirements"]
      _m = _m["Mission"]
      _m.ongoing = true
      missions.push _m


    for mission in missions

      # Create a mission object
      _m = GothamGame.MissionEngine.createMission mission
      _m.setOngoing mission.ongoing

      # Set complete callback, emitting back to server when its done.
      _m.onComplete = (mission) ->
        #console.log "#{mission._title} is complete!"


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

  updateView: ->
    @View.updateStats()





module.exports = MissionController
