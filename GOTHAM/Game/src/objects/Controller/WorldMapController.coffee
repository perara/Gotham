View = require '../View/WorldMapView.coffee'


class WorldMapController extends Gotham.Pattern.MVC.Controller


  constructor: (name) ->
    super View, name

  create: ->
    @create_nodes()
    @create_cables()
    @create_host()


  create_nodes: ->
    that = @
    # Clear node container (Else risking memory leak)
    that.View.clearNodeContainer()

    # Iterate Through the Node Table
    start = new Date().getTime()
    db_node = Gotham.Database.table "node"
    db_node().each (row) ->
      that.View.addNode row, true
    console.log "Process Nodes: " + (new Date().getTime() - start) + "ms"

  create_cables: ->
    that = @

    # Insert cables into -the "cables" table
    db_cable = Gotham.Database.table("cable")
    # Iterate Through the Cable Table
    start = new Date().getTime()
    db_cable().each (row) ->
      that.View.addCable row
    console.log "Process Cables: " + (new Date().getTime() - start) + "ms"

  create_host: ->

    db_user = Gotham.Database.table('user')
    user = db_user().first()

    for identity in user.Identities
      for network in identity.Networks
          @View.addNetwork(network)






module.exports = WorldMapController