


###*
# MissionEngine class which keeps track of all missions. Adding, Removal and emits for each of the missions.
# @class MissionEngine
# @module Frontend
# @submodule Frontend.Mission
# @namespace GothamGame.MissionEngine
###
class MissionEngine

  constructor: ->


    @_missions = {}

  # Create a mission object
  createMission: (missionData) ->
    mission = new GothamGame.Mission()

    mission.setID missionData.id
    mission.setTitle missionData.title
    mission.setExtendedDescription missionData.description_ext
    mission.setDescription missionData.description
    mission.setRequiredXP missionData.required_xp
    mission.addRequirements missionData.MissionRequirements
    mission.setMoneyGain missionData.money_gain
    mission.setExperienceGain missionData.experience_gain

    if missionData.UserMissionRequirements
      mission.setUserMissionID missionData.userMissionId
      mission.addUserMissionRequirements missionData.UserMissionRequirements

    return mission

  # Adds a mission by its object, requires it to have a name
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  addMission: (mission) ->

    # Add mission to arr
    @_missions[mission.id] = mission

    # Return Mission
    return mission

  # Removes an mission by object
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  removeMission: (mission) ->

    delete @_missions[mission.id]

    # Return Mission
    return mission

  emit: (emit, emit_value, _c) ->
    #console.log "[MISSION-E] Emitting #{name}, Value: #{emit_value}"
    for key, mission of @_missions
      mission.emit emit, emit_value, _c

    # Update view
    GothamGame.Renderer.getScene("World").getObject("Mission").updateView()





module.exports = MissionEngine



