View = require '../View/NodeListView.coffee'

###*
# NodeListController, Manages the NodeList data. Mainly only adding nodes to the list.
# @class NodeListController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class NodeListController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name
    @hide();


  create: ->

  show: ->
    @View.visible = true

  hide: ->
    @View.visible = false


module.exports = NodeListController