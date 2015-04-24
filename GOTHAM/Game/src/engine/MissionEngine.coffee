

class MissionEngine

  constructor: ->
    @_missions = {}


  # Adds a mission by its object, requires it to have a name
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  AddMission: (missiondata) ->

    console.log missiondata

    mission = new GothamGame.Mission()
    mission.SetTitle missiondata.title
    mission.SetDescription missiondata.description_ext
    mission.AddRequirements missiondata.MissionRequirements


    # Add mission to arr
    @_missions[mission.id] = mission

    # Return Mission
    return mission

  # Removes an mission by object
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  RemoveMission: (mission) ->

    delete @_missions[mission.id]

    # Return Mission
    return mission

  emit: (name, inVal, _c) ->
    #console.log "[MISSION-E] Emitting #{name}, Value: #{inVal}"


    for key, mission of @_missions
      mission.emit name, inVal, _c





module.exports = MissionEngine



