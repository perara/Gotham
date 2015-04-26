View = require '../View/NodeListView.coffee'

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