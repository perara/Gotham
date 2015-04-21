View = require '../View/MissionView.coffee'



class MissionController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name


  create: ->
    @SetupMissions()

    #@Hide()



  SetupMissions: ->

    db_mission = Gotham.Database.table("mission")
    missions = db_mission().first()

    console.log missions
    # Add Available Missions
    for mission in missions.available
      @View.AddAvailableMission(mission)

    # Add ongoing missions
    for mission in missions.ongoing
      @View.AddOngoingMission(mission)





  Show: ->
    @View.visible = true

  Hide: ->
    @View.visible = false






module.exports = MissionController
