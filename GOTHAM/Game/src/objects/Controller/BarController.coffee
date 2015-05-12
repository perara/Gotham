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
    GothamGame.Network.Socket.on 'World_Clock', (data) ->
      world_clock.label.text = data.text

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
          GothamGame.Globals.showAttacks = true
          home.tint = 0xFF0000
        else
          GothamGame.Globals.showAttacks = false
          home.tint = 0x4169E1
      home.click()
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
          GothamGame.Globals.showCables = true
          that.scene.getObject("WorldMap").View.setCableVisibility(GothamGame.Globals.showCables);
          home.tint = 0xFF0000
        else
          GothamGame.Globals.showCables = false
          that.scene.getObject("WorldMap").View.setCableVisibility(GothamGame.Globals.showCables);
          home.tint = 0x4169E1
      return home


  closeAll: (src) ->
    that = @
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

    if src != that.shop
      that.shop.tint = 0x4169E1
      that.shop.toggle = false
      that.scene.getObject("Shop").hide()

    if src != that.help
      that.help.tint = 0x4169E1
      that.help.toggle = false
      that.scene.getObject("Help").hide()
      GothamGame.Globals.canWheelScroll = true

  sideBarLeft: ->
    that = @

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
          that.closeAll(@)
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
          that.closeAll(@)
          that.scene.getObject("User").show()
          that.scene.getObject("User").View.bringToFront()
          user.tint = 0xFF0000
        else
          that.scene.getObject("User").hide()
          user.tint = 0x4169E1
      return user


    @View.addSidebarItem "LEFT", 15, ->
      that.shop = shop = new Gotham.Graphics.Sprite Gotham.Preload.fetch("shop", "image")
      shop.tint = 0x4169E1
      shop.alpha = 0.4
      shop.interactive = true
      shop.mouseover = -> @alpha = 1
      shop.mouseout = -> @alpha = 0.6
      shop.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          that.closeAll(@)
          that.scene.getObject("Shop").show()
          that.scene.getObject("Shop").View.bringToFront()
          @tint = 0xFF0000
        else
          @tint = 0x4169E1
          that.scene.getObject("Shop").hide()
      return shop


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
          that.closeAll(@)
          that.scene.getObject("Mission").show()
          that.scene.getObject("Mission").View.bringToFront()
          @tint = 0xFF0000
        else
          that.scene.getObject("Mission").hide()
          @tint = 0x4169E1
      return mission

    @View.addSidebarItem "LEFT", 450 ,->
      that.help = help = new Gotham.Graphics.Sprite Gotham.Preload.fetch("help", "image")
      help.tint = 0x4169E1
      help.alpha = 0.4
      help.interactive = true
      help.mouseover = -> @alpha = 1
      help.mouseout = -> @alpha = 0.6
      help.click = ->
        @toggle = if not @toggle then true else !@toggle

        if @toggle
          that.scene.getObject("Help").show()
          GothamGame.Globals.canWheelScroll = false
          @tint = 0xFF0000
        else
          that.scene.getObject("Help").hide()
          GothamGame.Globals.canWheelScroll = true
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


  bottomBar: ->





  updateCoordinates: (lat, long) ->
    @coordText.label.text = "Lat: #{lat}\nLng: #{long}"

  updateCountry: (country) ->
    c = if country then country.name else "None"
    @countryText.label.text = "Country: #{c}"



module.exports = BarController