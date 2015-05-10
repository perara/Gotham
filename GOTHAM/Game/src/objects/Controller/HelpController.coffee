View = require '../View/HelpView.coffee'

###*
# Manage data for the HelpView
# @class HelpController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class HelpController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @hide()
    that = @

    # Get Help content
    GothamGame.Network.Socket.emit 'GetHelpContent', {}
    GothamGame.Network.Socket.on 'GetHelpContent', (data) ->


      for category in data

        childrenContainer = that.View.addCategory category, null

        if category.Children.length > 0
          for child in category.Children
            that.View.addCategory child, childrenContainer





  show: ->
    @View.show()

  hide: ->
    @View.hide()



module.exports = HelpController



