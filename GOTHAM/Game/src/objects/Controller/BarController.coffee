View = require '../View/BarView.coffee'


class BarController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @topBar()
    #@bottomBar()
    @sideBar()


  topBar: ->
    that = @
    @coordText = null
    @countryText = null

    @View.addItem @View.Bar.Top, "LEFT", ->
      that.coordText = new Gotham.Controls.Button "Lat: 0\nLng: 0" , 100, 70
      return that.coordText

    @View.addItem @View.Bar.Top, "LEFT", ->
      that.countryText = new Gotham.Controls.Button "Country: None" , 100, 70, {margin: 50}
      return that.countryText

    world_clock = @View.addItem @View.Bar.Top, "RIGHT", ->
      that.clockText = new Gotham.Controls.Button "[WORLD_CLOCK]" , 100, 70, {offset: -10}
      return that.clockText


    # Emit for World_Clock
    GothamGame.Network.Socket.on 'World_Clock', (time) ->
      world_clock.label.text = time

  sideBar: ->
    that = @

    @View.addSidebarItem  15, ->
      home = new Gotham.Graphics.Sprite Gotham.Preload.fetch("home", "image")
      home.tint = 0x4169E1
      home.alpha = 0.4
      home.interactive = true
      home.mouseover = -> home.alpha = 1
      home.mouseout = -> home.alpha = 0.6
      home.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          that.scene.getObject("User").show()
          home.tint = 0xFF0000
        else
          that.scene.getObject("User").hide()
          home.tint = 0x4169E1
      return home

    @View.addSidebarItem 15, ->
      mission = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission", "image")
      mission.tint = 0x4169E1
      mission.alpha = 0.4
      mission.interactive = true
      mission.mouseover = -> @alpha = 1
      mission.mouseout = -> @alpha = 0.6
      mission.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          that.scene.getObject("Mission").show()
          @tint = 0xFF0000
        else
          that.scene.getObject("Mission").hide()
          @tint = 0x4169E1
      return mission

    @View.addSidebarItem 15, ->
      inventory = new Gotham.Graphics.Sprite Gotham.Preload.fetch("inventory", "image")
      inventory.tint = 0x4169E1
      inventory.alpha = 0.4
      inventory.interactive = true
      inventory.mouseover = -> @alpha = 1
      inventory.mouseout = -> @alpha = 0.6
      inventory.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          # TODO
          @tint = 0xFF0000
        else
          # TODO
          @tint = 0x4169E1
      return inventory

    @View.addSidebarItem 500 ,->
      help = new Gotham.Graphics.Sprite Gotham.Preload.fetch("help", "image")
      help.tint = 0x4169E1
      help.alpha = 0.4
      help.interactive = true
      help.mouseover = -> @alpha = 1
      help.mouseout = -> @alpha = 0.6
      help.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          # TODO
          @tint = 0xFF0000
        else
          # TODO
          @tint = 0x4169E1
      return help


    @View.addSidebarItem 15 ,->
      settings = new Gotham.Graphics.Sprite Gotham.Preload.fetch("settings", "image")
      settings.tint = 0x4169E1
      settings.alpha = 0.4
      settings.interactive = true
      settings.mouseover = -> @alpha = 1
      settings.mouseout = -> @alpha = 0.6
      settings.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          Settings = new GothamGame.Controllers.Settings "Settings"
          that.scene.addObject Settings
          @_settings = Settings
          @tint = 0xFF0000
        else
          that.scene.removeObject @_settings
          @tint = 0x4169E1
      return settings

    @View.addSidebarItem 15, ->
      menu = new Gotham.Graphics.Sprite Gotham.Preload.fetch("menu", "image")
      menu.tint = 0x4169E1
      menu.alpha = 0.4
      menu.interactive = true
      menu.mouseover = -> @alpha = 1
      menu.mouseout = -> @alpha = 0.6
      menu.click = ->
        GothamGame.Renderer.setScene("Menu")

      return menu



    #@_background.addChild home
    """ready = true
    home.tint = 0x4169E1
    home.click = ->
      if ready
        ready = false
        mapContainer.interactive = false
        home.tint = 0xFF0000

        prevSize =
          width : that.__width
          height : that.__height

        nextSize =
          width : mapContainer.width
          height : mapContainer.height

        diffSize =
          width: prevSize.width - nextSize.width
          height: prevSize.height - nextSize.height

        tween = new Gotham.Tween mapContainer
        tween.easing Gotham.Tween.Easing.Exponential.Out
        tween.to {position: {x: (diffSize.width / 2), y: (diffSize.height / 2)}}, 500
        tween.start()
        tween.onComplete () ->
          home.tint = 0x4169E1
          mapContainer.interactive = true
          mapContainer.offset.x = 0
          mapContainer.offset.y = 0
          ready = true
      """






  bottomBar: ->
    that = @

    # Create Terminal Button
    """@View.addItem @View.Bar.Bottom, "LEFT", ->

      button_terminal = new Gotham.Controls.Button "Home" , 100, 70

      button_terminal.toggleOn = (e) ->
        that.scene.getObject("User").show()

      button_terminal.toggleOff = (e) ->
        that.scene.getObject("User").hide()

      return button_terminal


    # Create Missions Button
    @View.addItem @View.Bar.Bottom,"LEFT", ->
      button_mission = new Gotham.Controls.Button "Missions" , 100, 70
      button_mission.toggleOn = (e) ->
        that.scene.getObject("Mission").show()
      button_mission.toggleOff = (e) ->
        that.scene.getObject("Mission").hide()
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
        that.scene.getObject("NodeList").show()

      button_node.toggleOff = (e) ->
        that.scene.getObject("NodeList").hide()
      return button_node


    # Create Menu Button
    @View.addItem @View.Bar.Bottom, "RIGHT" , ->
      button_menu = new Gotham.Controls.Button "Menu" , 100, 70, {toggle: false , textSize: 40}
      button_menu.click = (e) ->
        GothamGame.Renderer.setScene("Menu")
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


      return button_settings"""






  updateCoordinates: (lat, long) ->
    @coordText.label.text = "Lat: #{lat}\nLng: #{long}"

  updateCountry: (country) ->
    c = if country then country.name else "None"
    @countryText.label.text = "Country: #{c}"



module.exports = BarController