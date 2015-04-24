

describe 'Mission Tests', ->


  it 'Check that all properties are assigned', ->

    missionName = "KillMission"

    missionEngine = GothamGame.MissionEngine
    newMission = new GothamGame.Mission()
    newMission.setTitle missionName
    missionEngine.AddMission newMission

    assert.equal(newMission._engine, missionEngine)
    assert.equal(newMission._name, missionName)





  it 'Add Requirement and set value works correctly', ->
    newMission = new GothamGame.Mission()
    newMission.setTitle "KillMission"

    req = newMission.addRequirement("Killing").expect(10).default(0)
    assert.equal(req.currentValue, 0)
    assert.equal(req.expectValue, 10)
    assert.equal(req._mission, newMission)
    assert.equal(req.name, "Killing")





  it 'Does triggers work ?', ->
    missionEngine = GothamGame.MissionEngine

    callList =
      onCompleted : false
      onFailed: false
      onAccepted: false
      onProgress: false

    # Create Callbacks
    missionEngine.onMissionCompleted (e) ->
      callList.onCompleted = true
    missionEngine.onMissionFailed (e) ->
      callList.onFailed = true
    missionEngine.onMissionAccepted (e) ->
      callList.onAccepted = true
    missionEngine.onMissionProgress (e) ->
      callList.onProgress = true

    # Create mission
    newMission = new GothamGame.Mission "KillMission"
    missionEngine.AddMission newMission

    # Add a requirement with expected value 10 where default is 0
    newMission.addRequirement("Killing").expect(10).default(0)

    # Update Value to 9
    newMission.getRequirement("Killing").valueTo(9)
    newMission.getRequirement("Killing").valueTo(10)
    expect(callList.onProgress).equal(true)
    expect(callList.onCompleted).equal(true)



  it 'Test HackMission', ->
    missionEngine = GothamGame.MissionEngine

    variableExpect = false

    hackMission = new GothamGame.HackMission()

    hackMission.setTitle "Hack Prince Albert"
    hackMission.setDescription "Prince Albert have been on a hacking spree around the world \nWe require you to neutrilize this internet threat. His Official IP will be given"

    hackMission.addRequirement("Sensitive File").expect("sensetivefile.txt").default(null).description("Retrieve Prince Alberts sensetive file")
    hackMission.addRequirement("DDOS 60 Seconds").expect("60").default(0).description("DDOS Prince Alberts Host in 60 seconds")
    hackMission.addRequirement("Gain Root Access").expect(true).default(false).description("Gain Root access to Prince Alberts Host")
    hackMission.addRequirement("Destroy Evidence").expect(->
      return variableExpect
    ).default(false).description("Destroy evidence in Prince Alberts Host")

    variableExpect = "hest"
    hackMission.printMission()


    missionEngine.AddMission hackMission









