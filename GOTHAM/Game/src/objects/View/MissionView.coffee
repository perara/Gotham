

class MissionView extends Gotham.Pattern.MVC.View


  constructor: ->
    super


    @selectedMission = null
    @missionPages = []
    @currentMissionPage = 0
    @missionsPerPage = 5
    @missions = []


  create: ->
    @SetupListView()
    @InitMissionJournal()
    @UpdateMissionJournal()


  # This view displays a list of available missions, clicking on one of the missions.
  # Interacting with an item in the list opens up another view with mission details
  #
  SetupListView: ->
    that = @

    @window = window = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_background", "image")
    window.x = 190
    window.y = 110
    window.interactive = true # TODO PIXI-BUG
    window.click = (e) ->
    @addChild window

    availMissions = new Gotham.Graphics.Text("Available Missions", {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    availMissions.x = 35
    availMissions.y = 30
    window.addChild availMissions

    ongoingMissions = new Gotham.Graphics.Text("Ongoing Missions", {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    ongoingMissions.x = 35
    ongoingMissions.y = 420
    window.addChild ongoingMissions

    frame = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_frame", "image")
    window.addChild frame

    spacer = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_spacer", "image")
    spacer.y = 5
    spacer.x = window.width / 2

    window.addChild spacer






  # This view displays a selected mission, the user is able to select to start such mission type
  AddMission: (mission)->
    that = @

    missionItem = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_item", "image")

    # Add to page system
    page = Math.floor(@missions.length / @missionsPerPage)

    # If the page does not exist, create a new index and a button
    if not @missionPages[page]
      @missionPages[page] = []
      pageButton = new Gotham.Controls.Button (page+1), 25,25, 100, true
      pageButton.missions = []
      pageButton.x = 35 + (page * 25)
      pageButton.y = 370
      pageButton.interactive = true
      pageButton.click = ->
        that.currentMissionPage = page
        that.UpdateAvailableQuestList()
      that.window.addChild pageButton

    @missionPages[page].push missionItem

    @missions.push missionItem
    missionItem.y = 60 * (@missionPages[page].length)
    missionItem.x = 35
    missionItem.interactive = true
    missionItem.visible = false
    missionItem.mission = mission
    missionItem.click = ->
      @_toggle = if not @_toggle then true else !@_toggle

      if @_toggle
        for mission in that.missions
          if mission != @
            mission.tint = 0xffffff
            mission._toggle = false

        @tint = 0x00ff00
        that.selectedMission = @

      else
        @tint = 0xffffff
        that.selectedMission = null

      that.UpdateMissionJournal()
    that.UpdateAvailableQuestList()


    missionTitle = new Gotham.Graphics.Text(MissionView.replacePlaceholders mission, mission.title, {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    missionTitle.x = 10
    missionTitle.y = 15
    missionItem.addChild missionTitle

    missionXPReq = new Gotham.Graphics.Text("Req XP: #{mission.required_xp}", {font: "bold 20px calibri", fill: "#ffffff", align: "right"});
    missionXPReq.x = 270
    missionXPReq.y = 15
    missionItem.addChild missionXPReq

    @window.addChild missionItem

  # Update The quest list with pagination
  UpdateAvailableQuestList: () ->
    that = @

    # Hide all visible missions
    for mission in @missions
      mission.visible = false


    # Make page visible
    missions = @missionPages[@currentMissionPage]
    for mission in missions
      mission.visible = true


  InitMissionJournal: ->
    @noDisplayedMission = new Gotham.Graphics.Text("No Mission Selected", {font: "bold 45px calibri", fill: "#ffffff", align: "left"});
    @noDisplayedMission.x = 480
    @noDisplayedMission.y = 300
    @window.addChild @noDisplayedMission


    @missionTitle = new Gotham.Graphics.Text("IP Hacking", {font: "bold 45px calibri", fill: "#ffffff", align: "left"});
    @missionTitle.x = 480
    @missionTitle.y = 60
    @missionTitle.visible = false
    @window.addChild @missionTitle

    @missionDescription_title = new Gotham.Graphics.Text("Description", {font: "bold 30px calibri", fill: "#ffffff", align: "left"});
    @missionDescription_title.x = 480
    @missionDescription_title.y = 120
    @missionDescription_title.visible = false
    @window.addChild @missionDescription_title


    @missionDescription = new Gotham.Graphics.Text("[NO DESCRIPTION}", {wordWrap: true, wordWrapWidth: 400, font: "bold 20px calibri", fill: "#000000", align: "left"});
    @missionDescription.x = 480
    @missionDescription.y = 180
    @missionDescription.visible = false
    @window.addChild @missionDescription


  @replacePlaceholders =(missionData, text) ->
    for requirement in missionData.MissionRequirements
      text = text.replace("{#{requirement.requirement}}",requirement.expected)
    return text

  UpdateMissionJournal: ->



    if @selectedMission
      @noDisplayedMission.visible = false
      @missionDescription_title.visible = true


      @missionTitle.text = MissionView.replacePlaceholders(@selectedMission.mission, @selectedMission.mission.title).replace("\\n","\n")
      @missionTitle.visible = true

      @missionDescription.text = MissionView.replacePlaceholders(@selectedMission.mission, @selectedMission.mission.description).replace("\\n","\n")
      @missionDescription.visible = true


    else
      @noDisplayedMission.visible = true
      @missionTitle.visible = false
      @missionDescription_title.visible = false
      @missionDescription.visible = false













module.exports = MissionView