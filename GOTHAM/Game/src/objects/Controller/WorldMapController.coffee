View = require '../View/WorldMapView.coffee'


class WorldMapController extends Gotham.Pattern.MVC.Controller


  constructor: (name) ->
    super View, name

  create: ->
    @createNodes()
    @createCables()
    @createHost()
    @setupIPViking()

  createNodes: ->
    that = @
    # Clear node container (Else risking memory leak)
    that.View.clearNodeContainer()

    # Iterate Through the Node Table
    start = new Date().getTime()
    db_node = Gotham.Database.table "node"
    db_node().each (row) ->
      that.View.addNode row, true
    console.log "Process Nodes: " + (new Date().getTime() - start) + "ms"

  createCables: ->
    that = @

    # Insert cables into -the "cables" table
    db_cable = Gotham.Database.table("cable")
    # Iterate Through the Cable Table
    start = new Date().getTime()
    db_cable().each (row) ->
      that.View.addCable row
    console.log "Process Cables: " + (new Date().getTime() - start) + "ms"

  createHost: ->

    db_user = Gotham.Database.table('user')
    user = db_user().get()[0]

    for identity in user.Identities
      for network in identity.Networks
          @View.addNetwork(network)

    return

  # Create a emit listener for the IPViking stream
  # This stream is relayed from main server
  # Emiiter: IPViking_Attack
  setupIPViking: ->
    that = @
    GothamGame.Network.Socket.on 'IPViking_Attack', (json) ->

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

      # Pass animation if Gotham Engine is unactive
      if not Gotham.Running
        return

      that.View.animateAttack source, target







module.exports = WorldMapController