View = require '../View/WorldMapView.coffee'


class WorldMapController extends Gotham.Pattern.MVC.Controller


  constructor: (name) ->
    super View, name

  create: ->
    @Create_Nodes()
    @Create_Cables()
    @Create_Host()
    @Setup_IPViking()

  Create_Nodes: ->
    that = @
    # Clear node container (Else risking memory leak)
    that.View.ClearNodeContainer()

    # Iterate Through the Node Table
    start = new Date().getTime()
    db_node = Gotham.Database.table "node"
    db_node().each (row) ->
      that.View.AddNode row, true
    console.log "Process Nodes: " + (new Date().getTime() - start) + "ms"

  Create_Cables: ->
    that = @

    # Insert cables into -the "cables" table
    db_cable = Gotham.Database.table("cable")
    # Iterate Through the Cable Table
    start = new Date().getTime()
    db_cable().each (row) ->
      that.View.AddCable row
    console.log "Process Cables: " + (new Date().getTime() - start) + "ms"

  Create_Host: ->

    db_user = Gotham.Database.table('user')
    user = db_user().first()

    for identity in user.Identities
      for network in identity.Networks
          @View.AddNetwork(network)

  # Create a emit listener for the IPViking stream
  # This stream is relayed from main server
  # Emiiter: IPViking_Attack
  Setup_IPViking: ->
    that = @
    GothamGame.network.Socket.on 'IPViking_Attack', (json) ->

      attack = JSON.parse(json)

      source =
        latitude: attack.latitude
        longitude: attack.longitude
        country: attack.countrycode
        org: attack.org

      target =
        latitude: attack.latitude2
        longitude: attack.longitude2
        country: attack.countrycode2
        city2: attack.city2

      that.View.AnimateAttack source, target







module.exports = WorldMapController