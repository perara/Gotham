View = require '../View/MissionView.coffee'



class MissionController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name


  create: ->
    @SetupMissions()
    @SetupMissionEmitter()

    #@Hide()



  SetupMissionEmitter: () ->
    that = @

    # Whenever a mission has been accepted (OK from Server)
    GothamGame.network.Socket.on 'AcceptMission', (mission) ->
      GothamGame.MissionEngine.AddMission mission
      that.View.RemoveAvailableMission mission
      that.View.AddOngoingMission mission

    GothamGame.network.Socket.on 'AbandonMission', (mission) ->
      GothamGame.MissionEngine.RemoveMission mission
      that.View.AddAvailableMission mission
      that.View.RemoveOngoingMission mission


  SetupMissions: ->

    db_mission = Gotham.Database.table("mission")
    missions = db_mission().first()


    # Add ongoing missions
    for mission in missions.ongoing
      GothamGame.MissionEngine.AddMission mission
      @View.AddOngoingMission mission

    # Filter away Ongoing missions from Available Missions
    filter = missions.available.filter (mission)->
      for key, _m of missions.ongoing
        if _m.id == mission.id
          return 0
      return 1

    # Add Available Missions
    for mission in filter
      @View.AddAvailableMission(mission)






  Show: ->
    @View.visible = true

  Hide: ->
    @View.visible = false






module.exports = MissionController
