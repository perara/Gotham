View = require '../View/MissionView.coffee'



class MissionController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name


  create: ->
    @SetupMissions()



  SetupMissions: ->

    db_mission = Gotham.Database.table("mission")
    missions = db_mission().get()

    console.log missions

    for mission in missions
      @View.AddMission(mission)





  Show: ->
    @View.visible = true

  Hide: ->
    @View.visible = false






module.exports = MissionController
