View = require '../View/UserView.coffee'


class UserController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    @SetupIdentities()
    @SetupHosts()

    @View.Hide()



  SetupIdentities: ->
    db_user = Gotham.Database.table "user"
    identities = db_user().first().Identities


    for identity in identities

      identity = jQuery.extend({}, identity)
      delete identity.id
      delete identity.fk_user
      delete identity.Networks
      delete identity.lat
      delete identity.lng

      @View.AddIdentity identity

  SetupHosts: ->
    db_user = Gotham.Database.table "user"
    identities = db_user().first().Identities

    for identity in identities
      for network in identity.Networks
        @View.AddNetwork network
        for host in network.Hosts


          sprite = @View.AddHost network, host



          # Create a terminal
          terminal = new GothamGame.Controllers.Terminal "Terminal_#{host.ip}"
          terminal.View.create()
          terminal.SetIdentity(identity)
          terminal.SetHost(host)
          terminal.SetNetwork(network)
          terminal.create()
          sprite.terminal = terminal
          sprite.click = ->
            @__toggled = if not @__toggled then true else false

            if @__toggled
              @terminal.Show()
            else
              @terminal.Hide()


          sprite.mouseout = ->
            @tint = 0xffffff
          sprite.mouseover = ->
            @tint = 0xff0000











  Show: ->
    @View.Show()

  Hide: ->
    @View.Hide()



module.exports = UserController



