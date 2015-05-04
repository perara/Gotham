View = require '../View/IdentityView.coffee'

###*
# IdentityController, This controller manages data for the Identity + Host/Network view.
# @class IdentityController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
###
class IdentityController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @setupIdentities()
    @setupHosts()

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

  setupHosts: ->
    db_user = Gotham.Database.table "user"
    identities = db_user.data[0].Identities


    for identity in identities
      for network in identity.Networks
        @View.addNetwork network
        for host in network.Hosts
          sprite = @View.addHost network, host



          # Create a terminal
          terminal = new GothamGame.Controllers.Terminal "Terminal_#{host.ip}"
          terminal.View.create()
          terminal.setIdentity(identity)
          terminal.setHost(host)
          terminal.setNetwork(network)
          terminal.create()
          sprite.terminal = terminal
          sprite.click = ->
            @__toggled = if not @__toggled then true else false

            if @__toggled
              @terminal.show()
            else
              @terminal.hide()


          sprite.mouseout = ->
            @tint = 0xffffff
          sprite.mouseover = ->
            @tint = 0xff0000

  show: ->
    @View.show()

  hide: ->
    @View.hide()



module.exports = IdentityController



