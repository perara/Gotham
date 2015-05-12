View = require '../View/ShopView.coffee'


###*
# Controller which manages network purchase etc.
# @class ShopController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class ShopController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name
    @hide()

  create: ->

    networkPurchase = false
    hostPurchase = false
    networkButton = null
    hostButton = null

    @View.createCategory "Network", "- Purchase by clicking X then on a node on the map", 300, "500", (src, state) ->

      networkPurchase = state
      networkButton = src

      if state
        GothamGame.Announce.message "Click on a node to complete the purchase", "NORMAL", 50

    @View.createCategory "Host", "- Purchase by clicking X then on a network", 500, "500", (src, state) ->
      hostPurchase = state
      hostButton = src

      if state
        GothamGame.Announce.message "Click on a network to complete the purchase", "NORMAL", 50



    @scene.getObject("Identity").View.shopOnNetworkClick = (network) ->

      # If activated
      if hostPurchase
        hostButton.click()

        GothamGame.Network.Socket.emit 'ShopPurchaseHost', { id: network.id }

    @scene.getObject("WorldMap").View.shopOnNodeClick = (node) ->

      # If activated
      if networkPurchase
        networkButton.click()
        GothamGame.Network.Socket.emit 'ShopPurchaseNetwork', { id: node.id }


    # on purchase complete emits
    GothamGame.Network.Socket.on 'ShopPurchaseHost_Complete', (data) ->
      GothamGame.Announce.message "A host was successfully purchased!", "NORMAL", 50

    GothamGame.Network.Socket.on 'ShopPurchaseNetwork_Complete', (data) ->
      GothamGame.Announce.message "A network was successfully purchased!", "NORMAL", 50



  show: ->
    @View.show()
  hide: ->
    @View.hide()

module.exports = ShopController