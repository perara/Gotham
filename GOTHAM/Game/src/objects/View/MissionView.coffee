

class MissionView extends Gotham.Pattern.MVC.View


  constructor: ->
    super

    @movable()
    @click = ->
      @bringToFront()

    @selected = null

    @missions =
      ongoing:
        isOngoing: true
        elements: []
        index: 0
        elementsPerPage: 5
        numPages: 0
        y: 450
      available:
        isOngoing: false
        elements: []
        index: 0
        elementsPerPage: 5
        numPages: 0
        y: 60

  create: ->
    @setupListView()



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

    @noDisplayedMission = new Gotham.Graphics.Text("No Mission Selected", {font: "bold 45px calibri", fill: "#ffffff", align: "left"});
    @noDisplayedMission.x = 480
    @noDisplayedMission.y = 300
    @noDisplayedMission.visible = true
    @window.addChild @noDisplayedMission

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

    for element in container.elements
      if element.mission.id == mission.id
        container.elements.remove element
        @window.removeChild element
        break


  updateVisibility: ->

    for key, container of @missions
      start = container.index * container.elementsPerPage
      end = (container.index * container.elementsPerPage) + container.elementsPerPage

      for element in container.elements
        element.visible = false

      count = 0
      for i in [start...end]
        if container.elements[i]
          container.elements[i].visible = true
          container.elements[i].y = container.y + (count * container.elements[i].height) + (5 * count)
          count++




  generateMissionJournalItem: (mission, missionItem) ->
    that = @


    journalContainer = new Gotham.Graphics.Container
    journalContainer.visible = false
    @window.addChild journalContainer


    missionTitle = new Gotham.Graphics.Text(mission.getTitle(), {font: "bold 45px calibri", fill: "#ffffff", align: "left"});
    missionTitle.x = 480
    missionTitle.y = 60
    journalContainer.addChild missionTitle

    missionDescription_title = new Gotham.Graphics.Text("Description", {font: "bold 30px calibri", fill: "#ffffff", align: "left"});
    missionDescription_title.x = 480
    missionDescription_title.y = 120
    journalContainer.addChild missionDescription_title

    descText = if mission.getOngoing() then mission.getExtendedDescription() else mission.getDescription()
    missionDescription = new Gotham.Graphics.Text(descText , {wordWrap: true, wordWrapWidth: 400, font: "bold 20px calibri", fill: "#000000", align: "left"});
    missionDescription.x = 480
    missionDescription.y = 180
    journalContainer.addChild missionDescription

    # Create accept button if not ongoing
    if !mission.getOngoing()
      acceptButton = new Gotham.Controls.Button "Accept", 100, 50, {toggle: false, texture: Gotham.Preload.fetch("iron_button", "image"), textSize: 50}
      acceptButton.y = missionDescription.y + missionDescription.height + 20
      acceptButton.x = 480
      acceptButton.click = () ->
        that.selected.journalItem.visible = false
        that.selected = null
        GothamGame.Network.Socket.emit 'AcceptMission', { id: mission.getID() }
      journalContainer.addChild acceptButton
    else

      startY = missionDescription.y + missionDescription.height + 60
      for key, requirement of mission.getRequirements()
        current = if not requirement.getCurrent() then "None" else requirement.getCurrent()
        requirmentGraphics = new Gotham.Graphics.Text("#{requirement.getName()}: #{current}/#{requirement.getExpected()}", {font: "bold 20px calibri", fill: "#000000", align: "left"});
        requirmentGraphics.y = startY
        requirmentGraphics.x = 480
        missionItem.requirements.push requirmentGraphics
        journalContainer.addChild requirmentGraphics
        startY += requirmentGraphics.height + 5

      startY += 40
      if !mission.isCompleted()

        abandonButton = new Gotham.Controls.Button "Abandon", 100, 50, {toggle: false, texture: Gotham.Preload.fetch("iron_button", "image"), textSize: 50}
        abandonButton.y = startY
        abandonButton.x = 480
        abandonButton.interactive = true
        journalContainer.addChild abandonButton
        abandonButton.click = () ->
          that.selected.journalItem.visible = false
          that.selected = null

          GothamGame.Network.Socket.emit 'AbandonMission', {id: mission.getID() }
      else
        completeMissionButton = new Gotham.Controls.Button "Complete Mission", 100, 50, {toggle: false, texture: Gotham.Preload.fetch("iron_button", "image"), textSize: 35}
        completeMissionButton.y = startY
        completeMissionButton.x = 480
        journalContainer.addChild completeMissionButton
        completeMissionButton.click = () ->
          #that.selected = null
          GothamGame.Network.Socket.emit 'CompleteMission', {id: mission.getID() }




    return journalContainer

  updateStats: () ->
    for key, type of @missions
      for element in type.elements
        mission = element.mission
        requirements = mission.getRequirements()
        keys = Object.keys(requirements)
        for i in [0...element.requirements.length]
          current = if not requirements[keys[i]].getCurrent() then "None" else requirements[keys[i]].getCurrent()
          element.requirements[i].text = "#{requirements[keys[i]].getName()}: #{current}/#{requirements[keys[i]].getExpected()}"



# This view displays a selected mission, the user is able to select to start such mission type
  addMission: (mission, container)->
    that = @

    # Create the initial mission graphics
    missionItem = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission_item", "image")
    missionItem.y = container.y + (container.elements.length * missionItem.height) + (5 * container.elements.length)
    missionItem.x = 35
    missionItem.mission = mission
    missionItem.requirements = []
    missionItem.interactive = true
    missionItem.visible = true
    missionItem.journalItem = @generateMissionJournalItem(mission, missionItem)

    # Add to the container list
    container.elements.push missionItem


    pageNum = Math.ceil (container.elements.length / container.elementsPerPage)

    if container.numPages < pageNum
      container.numPages = pageNum
      pageButton = new Gotham.Controls.Button (pageNum), 25,25, {toggle: false, textSize: 100}
      pageButton.visible = true
      pageButton.x = (pageNum * 35)
      pageButton.y = container.y + (50 * container.elementsPerPage + 1) + (5 * container.elementsPerPage)
      pageButton.click = ->
        container.index = pageNum - 1
        that.updateVisibility()

      @window.addChild pageButton


    # Whenever a mission item is clicked
    missionItem.click = ->
      @_toggle = if not @_toggle then true else !@_toggle

      # Remove toggle from already selected item
      if that.selected
        that.selected.tint = 0xffffff
        that.selected.journalItem.visible = false
        that.selected._toggle = false
        that.noDisplayedMission.visible = true

      that.selected = missionItem

      if @_toggle
        @tint = 0x00ff00
        @journalItem.visible = true
        that.noDisplayedMission.visible = false
        that.selected = @
      else
        @tint = 0xffffff
        @journalItem.visible = false
        that.noDisplayedMission.visible = true
        that.selected = null


    title = if mission.isCompleted() and mission.getOngoing() then "#{mission.getTitle()} (Complete)" else mission.getTitle()
    missionTitle = new Gotham.Graphics.Text(title, {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    missionTitle.x = 10
    missionTitle.y = 15
    missionItem.addChild missionTitle

    missionXPReq = new Gotham.Graphics.Text("Req XP: #{mission.getRequiredXP()}", {font: "bold 20px calibri", fill: "#ffffff", align: "right"});
    missionXPReq.x = 270
    missionXPReq.y = 15
    missionItem.addChild missionXPReq

    @window.addChild missionItem

    @updateVisibility()


  # Update The quest list with pagination
  updateQuestList: (container) ->

    # Hide all visible missions
    for mission in container.elements
      mission.visible = false

    # Make page visible
    missions = container.pages[container.currentPage]
    for mission in missions
      mission.visible = true



module.exports = MissionView