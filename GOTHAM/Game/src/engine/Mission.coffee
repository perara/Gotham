

class Mission



  constructor: () ->
    @_title = null
    @_description = null
    @_engine = null


    @_requirements = []

    @onProgress = ->
    @onRequirementComplete = ->
    @onComplete = ->


  # Create a requirement to a mission
  #
  # @param requirement {Object} The requirement
  # @return {Requirement} The Requirement
  addRequirement: (requirementData)->
    #console.log "[MISSION] Added Requirement: #{requirementData.requirement}"
    requirement = new Requirement(@, requirementData)
    @_requirements.push requirement
    return requirement

  # Add a list of requirements
  #
  # @param requirementName {String} The name of the requirement
  # @return {Requirement} The Requirement
  addRequirements: (arr)->
    for i in arr
      @addRequirement(i)

  # Get a requirement by name
  #
  # @param requirementName {String} The requirement name
  # @return {Requirement}
  getRequirement: (requirementName) ->
    return @_requirements[requirementName]


  # Check if the mission is completed
  # Checks via all of the requirementrs
  #
  # @return {Boolean} True if completed, False if not
  isCompleted: ->
    isComplete = true
    for req in @_requirements
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
  getTitle: ->
    return @_title
  getDescription: ->
    return @_description


  emit: (emit_name, emit_value, _c) ->

    for requirement in @_requirements
      #console.log "[MISSION] Requirement #{requirement._requirement}"

      if requirement._emit == emit_name
        #console.log "[MISSION] Matched Requirement #{requirement._requirement}"
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


    emit: (input, _c) ->


      if @_complete
        return

      # Return if the input are not valid
      if input != @_emit_input
        throw new Error "Requirement input is invalid! Got #{input}, Expected: #{@_emit_input}"

      # Check which behaviour to use
      if @_emit_behaviour == "increment"
        @_current += parseInt(@_emit_value)
      else if @_emit_behaviour == "decrement"
        @_current -= parseInt(@_emit_value)
      else if @_emit_behaviour == "set"
        @_current = @_emit_value

      if ""+@_current == ""+@_expected
        @_complete = true
        @_mission.onRequirementComplete(@)
        if @_mission.isCompleted()
          @_mission.onComplete(@_mission)
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