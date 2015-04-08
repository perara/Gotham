View = require '../View/NodeListView.coffee'

class NodeListController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name
    @Hide();


  create: ->

  Show: ->
    @View.visible = true

  Hide: ->
    @View.visible = false


module.exports = NodeListController