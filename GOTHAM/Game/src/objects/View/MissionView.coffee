

class MissionView extends Gotham.Pattern.MVC.View


  constructor: ->
    super


    @missions =
      ongoing:
        isOngoing: true
        pages: []
        currentPage: 0
        elements: []
        elementsPerPage: 6
        selected: null
        y: 450
      available:
        isOngoing: false
        pages: []
        currentPage: 0
        elements: []
        elementsPerPage: 6
        selected: null
        y: 60

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



  AddOngoingMission: (mission) ->
    @AddMission(mission, @missions.ongoing)

  AddAvailableMission: (mission) ->
    @AddMission(mission, @missions.available)


  # This view displays a selected mission, the user is able to select to start such mission type
  AddMission: (mission, container)->
    that = @


    # Add to page system
    page = Math.floor(container.elements.length / container.elementsPerPage)

    # If the page does not exist, create a new index and a button
    if not container.pages[page]
      container.pages[page] = []
      pageButton = new Gotham.Controls.Button (page+1), 25,25, {toggle: false, textSize: 100}
      pageButton.missions = []
      pageButton.x = 35 + (page * 25)
      pageButton.y = container.y + (50 * container.elementsPerPage + 1) + (5 * container.elementsPerPage + 1)
      pageButton.interactive = true
      pageButton.click = ->
        container.currentPage = page
        that.UpdateQuestList(container)
      that.window.addChild pageButton


    # Create mission element
    missionItem = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_item", "image")
    missionItem.y = container.y + (missionItem.height * container.pages[page].length) + (5 * container.pages[page].length)
    missionItem.x = 35
    missionItem.interactive = true
    missionItem.visible = false
    missionItem.mission = mission
    missionItem.click = ->
      @_toggle = if not @_toggle then true else !@_toggle

      if @_toggle

        for key, container of that.missions
          for mission in container.elements
            if mission != @
              mission.tint = 0xffffff
              mission._toggle = false

        @tint = 0x00ff00
        container.selected = @

      else
        @tint = 0xffffff
        container.selected = null

      that.UpdateMissionJournal(container)


    missionTitle = new Gotham.Graphics.Text(MissionView.replacePlaceholders mission, mission.title, {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    missionTitle.x = 10
    missionTitle.y = 15
    missionItem.addChild missionTitle

    missionXPReq = new Gotham.Graphics.Text("Req XP: #{mission.required_xp}", {font: "bold 20px calibri", fill: "#ffffff", align: "right"});
    missionXPReq.x = 270
    missionXPReq.y = 15
    missionItem.addChild missionXPReq

    @window.addChild missionItem



    # Add item to pagination array | Add item to elements array
    container.pages[page].push missionItem
    container.elements.push missionItem
    that.UpdateQuestList(container)


  # Update The quest list with pagination
  UpdateQuestList: (container) ->
    # Hide all visible missions
    for mission in container.elements
      mission.visible = false

    # Make page visible
    missions = container.pages[container.currentPage]
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

    @acceptButton = new Gotham.Controls.Button "Accept", 100, 50, {toggle: false, texture: Gotham.Preload.fetch("iron_button", "image"), textSize: 50}
    console.log Gotham.Preload.fetch("iron_button", "image")
    @acceptButton.y = @missionDescription.y + @missionDescription.height + 20
    @acceptButton.visible = false
    @acceptButton.x = 480
    @acceptButton.click = () ->
      console.log ":D"

    @window.addChild @acceptButton


  @replacePlaceholders =(missionData, text) ->
    for requirement in missionData.MissionRequirements
      text = text.replace("{#{requirement.requirement}}",requirement.expected)
    return text

  UpdateMissionJournal:(container) ->
    container = if not container then {} else container

    # Hide if no mission is selected
    if not container.selected
      @noDisplayedMission.visible = true
      @missionTitle.visible = false
      @missionDescription_title.visible = false
      @missionDescription.visible = false
      @acceptButton.visible = false



    ################################
    # Show Mission logic


    @noDisplayedMission.visible = false
    @missionDescription_title.visible = true


    @missionTitle.text = MissionView.replacePlaceholders(container.selected.mission, container.selected.mission.title).replace("\\n","\n")
    @missionTitle.visible = true

    @missionDescription.text = MissionView.replacePlaceholders(container.selected.mission, container.selected.mission.description).replace("\\n","\n")
    @missionDescription.visible = true

    @acceptButton.visible = true













module.exports = MissionView