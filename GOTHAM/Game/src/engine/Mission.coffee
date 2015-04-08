

class Mission

  constructor: () ->
    @_name = null
    @_description = null
    @_engine = null


    @_requirements = {}


  # Create a requirement to a mission
  #
  # @param requirementName {String} The name of the requirement
  # @return {Requirement} The Requirement
  addRequirement: (requirementName)->
    requirement = new Requirement(requirementName,@)
    @_requirements[requirementName] = requirement
    return requirement

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
    @_name = title
  setDescription: (description) ->
    @_description = description
  getTitle: ->
    return @_name
  getDescription: ->
    return @_description



  generateEvent: (name, mission, trigger, requirement) ->
    event =
      name: name
      mission: mission
      trigger: trigger
      requirement: requirement
    return event

  triggerComplete: ->
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


  printMission: ->
    console.log "-----------------------------------"
    console.log "Mission Name: #{@_name}"
    console.log "Mission Description: #{@_description}"
    console.log "Requirements:"
    $.each(@_requirements, (key,val) ->
      console.log "\t#{val.name}: #{val.getCurrentValue()}/#{val.getExpectValue()}"
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
    constructor: (name, mission) ->
      @_mission = mission
      @name = name

      @expectValue = null
      @currentValue = null
      @completed = false
      @failValues = []


    # Expect value for the requirement, Basicly destination value
    #
    # @param expectValue {Object} The expected requirement value
    # @return {Requirement} The Requirement
    expect: (expectValue) ->
      @expectValue = expectValue
      return @

    # What the default value starts at
    #
    # @param defaultValue {Object} The default requirement value
    # @return {Requirement} The Requirement
    default: (defaultValue) ->
      @currentValue = defaultValue
      return @

    # Sets an description of the requirement
    #
    # @param description {String} The description
    # @return {Requirement} The Requirement
    description: (description) ->
      @description = description
      return @

    # Sets default value TO something
    #
    # @param value {Object} The value
    # @return {Requirement} The Requirement
    valueTo: (value) ->
      @currentValue = value

      # Trigger Progress on mission
      @_mission.triggerProgress @

      # Set completed status if its false
      @completed = if not @completed then @isComplete()

      return @

    # Check if the requirement is complete
    #
    # @return {Boolean} True if complete, False if not
    isComplete: ->
      return if @getCurrentValue() == @getExpectValue() then true else false

    getExpectValue: ->
      return if typeof(@expectValue) == "function" then @expectValue() else @expectValue
    getCurrentValue: ->
      return if typeof(@currentValue) == "function" then @currentValue() else @currentValue










module.exports = Mission