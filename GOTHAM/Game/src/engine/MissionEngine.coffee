

class MissionEngine

  constructor: ->
    @_missions = {}

    @_triggerCallbacks =
      missionCompleted: []
      missionFailed: []
      missionProgress: []
      missionAccepted: []

    @onTrigger = ->


  # Adds a mission by its object, requires it to have a name
  #
  # @param mission {Mission} The mission object
  # @return {Mission} The removed Mission Object
  addMission: (mission) ->
    # Add mission to dict
    @_missions[mission.name] = mission

    # Fetch added mission
    _m = @_missions[mission.name]
    _m._engine = @

    # Assign onTrigger to mission
    _m.onTrigger = @onTrigger

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

  # Adds a trigger by name, Currently supported is : missionCompleted, missionFailed, missionAccepted, missionProgress
  #
  # @param triggerName {String} The trigger name
  # @param _c {Callback} The trigger callback
  #
  on: (triggerName, _c) ->
    if triggerName == "missionCompleted" then @onMissionCompleted(_c)
    else if triggerName == "missionFailed" then @onMissionFailed(_c)
    else if triggerName == "missionAccepted" then @onMissionAccepted(_c)
    else if triggerName == "missionProgress" then @onMissionProgress(_c)
    else throw new Error "Trigger Type does not exist"

  # Fires when a mission is completed
  #
  # @param _c {Callback} The Trigger callback
  #
  onMissionCompleted: (_c) ->
    @_triggerCallbacks.missionCompleted.push _c

  # Fires when a mission failed
  #
  # @param _c {Callback} The Trigger callback
  #
  onMissionFailed: (_c) ->
    @_triggerCallbacks.missionFailed.push _c

  # Fires when a mission is accepted
  #
  # @param _c {Callback} The Trigger callback
  #
  onMissionAccepted: (_c) ->
    @_triggerCallbacks.missionAccepted.push _c

  # Fires when a mission progressed further
  #
  # @param _c {Callback} The Trigger callback
  #
  onMissionProgress: (_c) ->
    @_triggerCallbacks.missionProgress.push _c


module.exports = MissionEngine



