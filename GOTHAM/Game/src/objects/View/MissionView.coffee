

class MissionView extends Gotham.Pattern.MVC.View


  constructor: ->
    super

    @selected = null
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
    @setupListView()
    @initMissionJournal()
    @updateMissionJournal()



  # This view displays a list of available missions, clicking on one of the missions.
  # Interacting with an item in the list opens up another view with mission details
  #
  setupListView: ->
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



  addOngoingMission: (mission) ->
    @addMission(mission, @missions.ongoing)

  removeOngoingMission: (mission) ->
    @removeMission mission, @missions.ongoing

  addAvailableMission: (mission) ->
    @addMission(mission, @missions.available)

  removeAvailableMission: (mission) ->
    @removeMission mission, @missions.available

  removeMission: (mission, container) ->



    # Remove From elements
    for sprite in container.elements
      if sprite.mission.id == mission.id
        container.elements.remove sprite
        break

    # Remove from page system # TODO , bad logic
    for page in container.pages
      for sprite in page
        if sprite.mission.id == mission.id
          page.remove sprite
          @window.removeChild sprite
          break

    container.selected = null
    @updateMissionJournal container



  # This view displays a selected mission, the user is able to select to start such mission type
  addMission: (mission, container)->
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
        that.updateQuestList(container)
      that.window.addChild pageButton


    # Create mission element
    missionItem = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_item", "image")
    missionItem.y = container.y + (missionItem.height * container.pages[page].length) + (5 * container.pages[page].length)
    missionItem.x = 35
    missionItem.interactive = true
    missionItem.visible = false
    missionItem.mission = mission
    missionItem.container = container
    missionItem.click = ->
      @_toggle = if not @_toggle then true else !@_toggle

      # Set Selected Mission Item
      that.selected = missionItem

      if @_toggle

        for key, container of that.missions
          for mission in container.elements
            if mission != @
              mission.tint = 0xffffff
              mission._toggle = false

        @tint = 0x00ff00
        @container.selected = @
      else
        @tint = 0xffffff
        @container.selected = null
      that.updateMissionJournal(@container)


    missionTitle = new Gotham.Graphics.Text(mission.getTitle(), {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    missionTitle.x = 10
    missionTitle.y = 15
    missionItem.addChild missionTitle

    missionXPReq = new Gotham.Graphics.Text("Req XP: #{mission.getRequiredXP()}", {font: "bold 20px calibri", fill: "#ffffff", align: "right"});
    missionXPReq.x = 270
    missionXPReq.y = 15
    missionItem.addChild missionXPReq

    @window.addChild missionItem

    # Add item to pagination array | Add item to elements array
    container.pages[page].push missionItem
    container.elements.push missionItem
    that.updateQuestList(container)


  # Update The quest list with pagination
  updateQuestList: (container) ->

    # Hide all visible missions
    for mission in container.elements
      mission.visible = false

    # Make page visible
    missions = container.pages[container.currentPage]
    for mission in missions
      mission.visible = true


  initMissionJournal: ->
    that = @

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

    @missionRequirements = new Gotham.Graphics.Text("[NO REQUIREMENTS}", {wordWrap: true, wordWrapWidth: 400, font: "bold 20px calibri", fill: "#000000", align: "left"});
    @missionRequirements.x = 480
    @missionRequirements.y = 250
    @missionRequirements.visible = false
    @window.addChild @missionRequirements

    @acceptButton = new Gotham.Controls.Button "Accept", 100, 50, {toggle: false, texture: Gotham.Preload.fetch("iron_button", "image"), textSize: 50}
    @acceptButton.y = @missionDescription.y + @missionDescription.height + 20
    @acceptButton.visible = false
    @acceptButton.x = 480
    @window.addChild @acceptButton
    @acceptButton.click = () ->
      GothamGame.Network.Socket.emit 'AcceptMission', that.selected.mission

    @abandonButton = new Gotham.Controls.Button "Abandon", 100, 50, {toggle: false, texture: Gotham.Preload.fetch("iron_button", "image"), textSize: 50}
    @abandonButton.y = @missionDescription.y + @missionDescription.height + 20
    @abandonButton.visible = false
    @abandonButton.x = 480
    @window.addChild @abandonButton
    @abandonButton.click = () ->
      console.log that.selected.mission
      GothamGame.Network.Socket.emit 'AbandonMission', that.selected.mission




  updateMissionJournal:(container) ->
    container = if not container then {} else container




    # Hide if no mission is selected
    if not container.selected
      @noDisplayedMission.visible = true
      @missionTitle.visible = false
      @missionDescription_title.visible = false
      @missionDescription.visible = false
      @acceptButton.visible = false
      @abandonButton.visible = false
      @missionRequirements.visible = false
      return

    ################################
    # Show Mission logic
    # Only show accept button on available mission
    if not container.isOngoing
      @acceptButton.visible = true
      @abandonButton.visible = false
      @missionRequirements.visible = false
      missionDescription = container.selected.mission.getDescription()
    else
      @acceptButton.visible = false
      @abandonButton.visible = true
      @missionRequirements.visible = true

      # Set Text of mission Requirements
      reqStr = ""
      for id, req of container.selected.mission.getRequirements()
        reqStr += "#{req.getName()}: #{req.getCurrent()} / #{req.getExpected()}\n"
      @missionRequirements.text = reqStr


      # Move abandon button to bottom
      @abandonButton.y = @missionRequirements.y + @abandonButton.height + 20
      missionDescription = container.selected.mission.getExtendedDescription()







    @noDisplayedMission.visible = false
    @missionDescription_title.visible = true
    #MissionView.replacePlaceholders(container.selected.mission, container.selected.mission._title).replace("\\n","\n")
    @missionTitle.text = container.selected.mission.getTitle()
    @missionTitle.visible = true

    #MissionView.replacePlaceholders(container.selected.mission, missionDescription).replace("\\n","\n")
    @missionDescription.text = missionDescription
    @missionDescription.visible = true


















module.exports = MissionView