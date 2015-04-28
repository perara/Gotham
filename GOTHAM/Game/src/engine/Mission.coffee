

class Mission



  constructor: () ->
    @id = null
    @_title = null
    @_description = null
    @_description_ext = null
    @_requiredXP = null
    @_engine = null
    @_data = null


    @_requirements = {}

    @onProgress = ->
    @onRequirementComplete = ->
    @onComplete = ->



  # Update state of a mission, Eventually triggers onComplete if it is complete.
  updateState: ->
    if @isCompleted()
      @onComplete(@)

  # Create a requirement to a mission
  #
  # @param requirement {Object} The requirement
  # @return {Requirement} The Requirement
  addRequirement: (requirementData) ->
    #console.log "[MISSION] Added Requirement: #{requirementData.requirement}"
    requirement = new Requirement(@, requirementData)
    @_requirements[requirementData.id] =  requirement
    return requirement

  addUserMissionRequirement: (userMissionRequirementData) ->

    # Retrieve the requirement
    requirement = @_requirements[userMissionRequirementData.mission_requirement]
    requirement.setCurrent userMissionRequirementData.current
    requirement.setExpected userMissionRequirementData.expected
    requirement.setEmitInput userMissionRequirementData.emit_input
    requirement.setEmitValue userMissionRequirementData.emit_value
    requirement.userMissionRequirementData = userMissionRequirementData




  # Add a list of requirements
  #
  # @param requirementName {String} The name of the requirement
  # @return {Requirement} The Requirement
  addRequirements: (arr)->
    for i in arr
      @addRequirement i

  addUserMissionRequirements: (arr)->
    for i in arr
      @addUserMissionRequirement i

  # Get a requirement by name
  #
  # @param requirementName {String} The requirement name
  # @return {Requirement}
  getRequirement: (requirementName) ->
    return @_requirements[requirementName]

  getRequirements: () ->
    return @_requirements


  # Check if the mission is completed
  # Checks via all of the requirementrs
  #
  # @return {Boolean} True if completed, False if not
  isCompleted: ->
    isComplete = true
    for idx, req of @_requirements
      if not req.isComplete()
        isComplete = false
        break
    return isComplete

  setTitle: (title) ->
    #console.log "[MISSION] Set Title to: #{title}"
    @_title = title

  setDescription: (description) ->
    #console.log "[MISSION] Set Title to: #{description}"
    @_description = description

  setExtendedDescription: (description_ext) ->
    @_description_ext = description_ext

  setRequiredXP: (xp) ->
    @_requiredXP = xp
  setID: (id) ->
    @id = id

  getID: ->
    return @id


  getTitle: ->
    return @_title
  getDescription: ->
    return @_description
  getExtendedDescription: () ->
    return @_description_ext

  getRequiredXP: () ->
    return @_requiredXP

  emit: (emit_name, emit_value, _c) ->

    for key, requirement of @_requirements
      #console.log "[MISSION] Requirement #{requirement._requirement}"

      if requirement._emit == emit_name
        console.log "[MISSION] Matched Requirement #{requirement._requirement}"
        requirement.emit emit_value, _c







  generateEvent: (name, mission, trigger, requirement) ->
    event =
      name: name
      mission: mission
      trigger: trigger
      requirement: requirement
    return event

  """triggerComplete: ->
    for callback in  @_engine._triggerCallbacks.missionCompleted
      callback(@generateEvent(@_name, @, "complete"))

  triggerFailed: ->
    for callback in  @_engine._triggerCallbacks.missionFailed
      callback(@generateEvent(@_name, @, "failed"))

  # Trigger for progress, Takes option Requirement input
  #
  # @param requirement {Requirement} The requirement
  #
  triggerProgress: (requirement) ->
    for callback in  @_engine._triggerCallbacks.missionProgress
      callback(@generateEvent(@_name, @, "progress", requirement))

    # Check if all requirements is completed
    if @isCompleted()
      @triggerComplete()

  triggerAccepted: ->
    for callback in  @_engine._triggerCallbacks.missionAccepted
      callback(@generateEvent(@_name, @, "accepted"))
  """


  printMission: ->
    console.log "-----------------------------------"
    console.log "Mission Name: #{@_title}"
    console.log "Mission Description: #{@_description}"
    console.log "Requirements:"
    $.each(@_requirements, (key,val) ->
      console.log "\t#{val._requirement}: #{val.getCurrentValue()}/#{val.getExpectedValue()}"
    )

    console.log "-----------------------------------"



  # Chain based class to create an requirement for an mission
  #
  # @example How to chain Requirement
  #   mission.addRequirement("hack").expect("10").default("0").description("Hack 10 targets")
  #
  class Requirement

    # Creates an requirement object
    #
    # @param name {String} The Requireement Title
    constructor: (mission, requirementData) ->
      @_requirementData = requirementData

      # Database Fields
      @_id = requirementData.id
      @_mission = @mission = mission
      @_requirement = requirementData.requirement
      @_current = requirementData.default
      @_expected = requirementData.expected
      @_emit = requirementData.emit
      @_emit_value = requirementData.emit_value
      @_emit_input = requirementData.emit_input
      @_emit_behaviour = requirementData.emit_behaviour

      # Internal Definition
      @_complete = false

    getCurrent: ->
      return @_current
    getExpected: ->
      return @_expected
    getName: ->
      return @_requirement

    setCurrent: (current) ->
      @_current = current
      @isComplete()

    setExpected: (expected) ->
      @_expected = expected
      @isComplete()

    setEmitValue: (emitValue) ->
      @_emit_value = emitValue

    setEmitInput: (emitInput) ->
      @_emit_input = emitInput

    isComplete: ->
      if ""+@_current == ""+@_expected
        @_complete = true
      return @_complete

    emit: (input, _c) ->

      if @_complete
        return

      # Throw error of input and emit input does not match
      if input != @_emit_input
        console.warn "Requirement input is invalid! Got #{input}, Expected: #{@_emit_input}"
        return

      # Increment Behaviour - Increments @_emit_value to the @_current value
      if @_emit_behaviour == "increment"
        @_current = parseInt(@_current)
        @_current += parseInt(@_emit_value)

      # Decrement Behaviour - Decrements @_emit_value to the @_current value
      else if @_emit_behaviour == "decrement"
        @_current = parseInt(@_current)
        @_current -= parseInt(@_emit_value)

      # Set Behaviour - Sets @_current equal to @_emit_value
      else if @_emit_behaviour == "set"
        @_current = @_emit_value

      # If Current and Expected value are equal, Fire onComplete and set requirement to complete
      if ""+@_current == ""+@_expected
        # Requirement is complete
        @_complete = true

        _c(@)

        # Fire Requirement Complete Callback
        @_mission.onRequirementComplete(@)

        # Check if Mission is complete
        if @_mission.isCompleted()
          @_mission.onComplete(@_mission)

      # Send Progress Callback
      else
        @_mission.onProgress(@)



















    # Check if the requirement is complete
    #
    # @return {Boolean} True if complete, False if not
    isComplete: ->
      return if ""+@getCurrentValue() == ""+@getExpectedValue() then true else false

    getExpectedValue: ->
      return if typeof(@_expected) == "function" then @expectValue() else @_expected

    getCurrentValue: ->
      return if typeof(@_current) == "function" then @currentValue() else @_current










module.exports = Mission