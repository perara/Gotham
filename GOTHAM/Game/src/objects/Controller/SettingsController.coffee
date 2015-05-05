View = require '../View/SettingsView.coffee'


###*
# SettingsController, This controller does basically nothing. But in the future should hold different Game settings
# @class SettingsController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class SettingsController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name


  create: ->


module.exports = SettingsController