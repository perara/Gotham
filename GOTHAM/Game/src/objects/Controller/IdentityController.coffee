View = require '../View/IdentityView.coffee'

###*
# IdentityController, This controller manages data for the Identity + Host/Network view.
# @class IdentityController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class IdentityController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @setupIdentities()
    @setupHosts()
    @emitNetwork()
    @emitHost()

    @View.hide()



  setupIdentities: ->
    db_user = Gotham.Database.table "user"
    identities = db_user.data[0].Identities


    for identity in identities

      identity = jQuery.extend({}, identity)
      delete identity.id
      delete identity.fk_user
      delete identity.Networks
      delete identity.lat
      delete identity.lng

      @View.addIdentity identity

  ###*
  # Emits for when Networks has been updated. For example a purchase
  # @method emitNetwork
  ###
  emitNetwork: ->
    that = @
    GothamGame.Network.Socket.on 'NetworkPurchaseUpdate', (network) ->
      that.View.addNetwork network

  ###*
  # Emits for when A host has been purchased,
  # @method emitHost
  ###
  emitHost: ->
    that = @

    GothamGame.Network.Socket.on 'HostPurchaseUpdate', (host) ->
      sprite = that.View.addHost host.Network, host
      that.createTerminal sprite, host, host.Network, host.Identity
      that.View.redraw()



  setupHosts: ->
    db_user = Gotham.Database.table "user"
    identities = db_user.data[0].Identities


    for identity in identities
      for network in identity.Networks
        @View.addNetwork network
        for host in network.Hosts
          sprite = @View.addHost network, host

          @createTerminal sprite, host, network, identity

    @View.redraw()





  createTerminal: (sprite, host, network, identity)->

    # Create a terminal
    terminal = new GothamGame.Controllers.Terminal "Terminal_#{host.ip}"
    terminal.View.create()
    terminal.setIdentity(identity)
    terminal.setHost(host)
    terminal.setNetwork(network)
    terminal.create()
    sprite.terminal = terminal
    sprite.click = ->
      @terminal.toggle()


    sprite.mouseout = ->
      @tint = 0xffffff
    sprite.mouseover = ->
      @tint = 0xff0000

  show: ->
    @View.show()

  hide: ->
    @View.hide()



module.exports = IdentityController



