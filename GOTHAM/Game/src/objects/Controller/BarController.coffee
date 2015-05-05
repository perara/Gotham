View = require '../View/BarView.coffee'

###*
# Bar Controller keeps track of all menus is the World Scene. Left, Top, Right, Bottom bar.
# @class BarController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class BarController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @topBar()
    #@bottomBar()
    @sideBarLeft()
    @sideBarRight()

  topBar: ->
    that = @
    @coordText = null
    @countryText = null

    @View.addItem @View.Bar.Top, "LEFT", ->
      that.coordText = new Gotham.Controls.Button "Lat: 0\nLng: 0" , 100, 70, {alpha: 0}
      return that.coordText

    @View.addItem @View.Bar.Top, "LEFT", ->
      that.countryText = new Gotham.Controls.Button "Country: None" , 100, 70, {margin: 50, alpha: 0}
      return that.countryText

    world_clock = @View.addItem @View.Bar.Top, "RIGHT", ->
      that.clockText = new Gotham.Controls.Button "[WORLD_CLOCK]" , 100, 70, {offset: -10, alpha: 0}
      return that.clockText


    # Emit for World_Clock
    GothamGame.Network.Socket.on 'World_Clock', (time) ->
      world_clock.label.text = time

  sideBarRight: ->
    that = @

    @View.addSidebarItem  "RIGHT", 15, ->
      home = new Gotham.Graphics.Sprite Gotham.Preload.fetch("attack", "image")
      home.tint = 0x4169E1
      home.alpha = 0.4
      home.interactive = true
      home.mouseover = -> home.alpha = 1
      home.mouseout = -> home.alpha = 0.6
      home.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          #DO SOMTHING
          home.tint = 0xFF0000
        else
          # DO SOMTHING
          home.tint = 0x4169E1
      return home

    @View.addSidebarItem  "RIGHT", 15, ->
      home = new Gotham.Graphics.Sprite Gotham.Preload.fetch("cable", "image")
      home.tint = 0x4169E1
      home.alpha = 0.4
      home.interactive = true
      home.mouseover = -> home.alpha = 1
      home.mouseout = -> home.alpha = 0.6
      home.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          #DO SOMTHING
          home.tint = 0xFF0000
        else
          # DO SOMTHING
          home.tint = 0x4169E1
      return home


  sideBarLeft: ->
    that = @

    closeAll = (src) ->
      # Home Button (Identity)
      if src != that.home
        that.home.tint = 0x4169E1
        that.home.toggle = false
        that.scene.getObject("Identity").hide()

      # User Button (User)
      if src != that.user
        that.user.tint = 0x4169E1
        that.user.toggle = false
        that.scene.getObject("User").hide()

      if src != that.mission
        that.mission.tint = 0x4169E1
        that.mission.toggle = false
        that.scene.getObject("Mission").hide()

      if src != that.inventory
        that.inventory.tint = 0x4169E1
        that.inventory.toggle = false
        # TODO add inventory




    @View.addSidebarItem  "LEFT", 15, ->
      that.home = home = new Gotham.Graphics.Sprite Gotham.Preload.fetch("home", "image")
      home.tint = 0x4169E1
      home.alpha = 0.4
      home.interactive = true
      home.mouseover = -> home.alpha = 1
      home.mouseout = -> home.alpha = 0.6
      home.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          closeAll(@)
          that.scene.getObject("Identity").show()
          that.scene.getObject("Identity").View.bringToFront()
          home.tint = 0xFF0000
        else
          that.scene.getObject("Identity").hide()
          home.tint = 0x4169E1
      return home

    @View.addSidebarItem  "LEFT", 15, ->
      that.user = user = new Gotham.Graphics.Sprite Gotham.Preload.fetch("user", "image")
      user.tint = 0x4169E1
      user.alpha = 0.4
      user.interactive = true
      user.mouseover = -> user.alpha = 1
      user.mouseout = -> user.alpha = 0.6
      user.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          closeAll(@)
          that.scene.getObject("User").show()
          that.scene.getObject("User").View.bringToFront()
          user.tint = 0xFF0000
        else
          that.scene.getObject("User").hide()
          user.tint = 0x4169E1
      return user


    @View.addSidebarItem "LEFT", 15, ->
      that.inventory = inventory = new Gotham.Graphics.Sprite Gotham.Preload.fetch("inventory", "image")
      inventory.tint = 0x4169E1
      inventory.alpha = 0.4
      inventory.interactive = true
      inventory.mouseover = -> @alpha = 1
      inventory.mouseout = -> @alpha = 0.6
      inventory.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          closeAll(@)
          @tint = 0xFF0000
        else
          # TODO
          @tint = 0x4169E1
      return inventory


    @View.addSidebarItem "LEFT", 15, ->
      that.mission = mission = new Gotham.Graphics.Sprite Gotham.Preload.fetch("mission", "image")
      mission.tint = 0x4169E1
      mission.alpha = 0.4
      mission.interactive = true
      mission.mouseover = -> @alpha = 1
      mission.mouseout = -> @alpha = 0.6
      mission.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          closeAll(@)
          that.scene.getObject("Mission").show()
          that.scene.getObject("Mission").View.bringToFront()
          @tint = 0xFF0000
        else
          that.scene.getObject("Mission").hide()
          @tint = 0x4169E1
      return mission

    @View.addSidebarItem "LEFT", 450 ,->
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

    @View.addSidebarItem "LEFT", 15 ,->
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

    @View.addSidebarItem "LEFT", 15, ->
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





  updateCoordinates: (lat, long) ->
    @coordText.label.text = "Lat: #{lat}\nLng: #{long}"

  updateCountry: (country) ->
    c = if country then country.name else "None"
    @countryText.label.text = "Country: #{c}"



module.exports = BarController