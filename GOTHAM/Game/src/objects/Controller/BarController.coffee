View = require '../View/BarView.coffee'


class BarController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @topBar()
    @bottomBar()


  topBar: ->
    that = @
    @coordText = null
    @countryText = null

    @View.addItem @View.Bar.Top, "LEFT", ->
      that.coordText = text = new Gotham.Graphics.Text("Lat: 0\nLng: 0", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
      text.width = 200
      text.anchor =
        x: 0
        y: 0
      text.margin = 50
      return text

    @View.addItem @View.Bar.Top, "LEFT", ->
      that.countryText = text = new Gotham.Graphics.Text("Country: None", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
      text.width = 200
      text.anchor =
        x: 0
        y: 0
      return text






  bottomBar: ->
    that = @

    # Create Terminal Button
    @View.addItem @View.Bar.Bottom, "LEFT", ->

      button_terminal = new Gotham.Controls.Button "Home" , 100, 70

      console.log that.scene
      button_terminal.toggleOn = (e) ->
        that.scene.getObject("User").Show()

      button_terminal.toggleOff = (e) ->
        that.scene.getObject("User").Hide()

      return button_terminal


    # Create Missions Button
    @View.addItem @View.Bar.Bottom,"LEFT", ->
      button_mission = new Gotham.Controls.Button "Missions" , 100, 70
      button_mission.toggleOn = (e) ->
        that.scene.getObject("Mission").Show()
      button_mission.toggleOff = (e) ->
        that.scene.getObject("Mission").Hide()
      return button_mission

      # Create Missions Button
    @View.addItem @View.Bar.Bottom,"LEFT", ->
      button_inventory = new Gotham.Controls.Button "Inventory" , 100, 70
      button_inventory.toggleOn = (e) ->
      button_inventory.toggleOff = (e) ->
      return button_inventory

    # Create Missions Button
    @View.addItem @View.Bar.Bottom, "LEFT", ->
      button_node = new Gotham.Controls.Button "Nodes" , 100, 70
      button_node.toggleOn = (e) ->
        that.scene.getObject("NodeList").Show()

      button_node.toggleOff = (e) ->
        that.scene.getObject("NodeList").Hide()
      return button_node


    # Create Menu Button
    @View.addItem @View.Bar.Bottom, "RIGHT" , ->
      button_menu = new Gotham.Controls.Button "Menu" , 100, 70, {toggle: false , textSize: 40}
      button_menu.click = (e) ->
        GothamGame.renderer.setScene("Menu")
      return button_menu

    # Create Menu Button
    @View.addItem @View.Bar.Bottom, "RIGHT" , ->
      button_settings = new Gotham.Controls.Button "Settings" , 100, 70, {toggle: true, textSize: 40}
      button_settings.toggleOn = (e) ->
        Settings = new GothamGame.Controllers.Settings "Settings"
        that.scene.addObject Settings
        @_settings = Settings
      button_settings.toggleOff = (e) ->
        that.scene.removeObject @_settings


      return button_settings




  updateCoordinates: (lat, long) ->
    @coordText.text = "Lat: #{lat}\nLng: #{long}"

  updateCountry: (country) ->
    c = if country then country.name else "None"
    @countryText.text = "Country: #{c}"


















module.exports = BarController