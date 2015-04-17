

class MissionEngine

  constructor: ->
    @_missions = {}


  # Adds a mission by its object, requires it to have a name
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  addMission: (mission) ->
    # Add mission to dict

    @_missions[mission._title] = mission

    # Fetch added mission
    _m = @_missions[mission._title]
    _m._engine = @

    # Return Mission
    return _m

  # Removes an mission by object
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  removeMission: (mission) ->
    # Fetch mission to delete
    _m = @_missions[mission.name]
    _m._engine = null

    # Delete mission from dict
    delete @_missions[mission.name]

    # Return Mission
    return _m

  # Fetch a mission by its Name
  #
  # @param missionName {String} The mission name
  # @return {Mission} Mission Object
  getMission: (missionName) ->
    # Fetch Mission by key/name
    _m = @_missions[missionName]

    # Return Mission
    return _m

  emit: (name, inVal, _c) ->
    #console.log "[MISSION-E] Emitting #{name}, Value: #{inVal}"


    for key, mission of @_missions
      mission.emit name, inVal, _c





module.exports = MissionEngine



