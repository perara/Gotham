View = require '../View/MissionView.coffee'



class MissionController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name


  create: ->
    @setupMissions()
    @setupMissionEmitter()

    #@Hide()



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
      _m = GothamGame.MissionEngine.createMission mission

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
