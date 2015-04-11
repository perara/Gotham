View = require '../View/WorldMapView.coffee'


class WorldMapController extends Gotham.Pattern.MVC.Controller


  constructor: (name) ->
    super View, name

  create: ->
    @create_nodes()


  create_nodes: ->
    that = @

    GothamGame.network.Socket.emit 'GetNodes'
    GothamGame.network.Socket.emit 'GetCables'


    GothamGame.network.Socket.on "GetNodes" , (json) ->
      nodes = JSON.parse json

      # Insert the nodes into the "node" table
      db_node = GothamGame.Database.table("node")
      db_node.insert nodes

      # Iterate Through the Node Table
      start = new Date().getTime()
      db_node().each (row) ->
        that.View.addNode row
      console.log "Process Nodes: " + (new Date().getTime() - start) + "ms"


    GothamGame.network.Socket.on "GetCables" , (json) ->
      cables = JSON.parse json

      # Insert cables into the "cables" table
      db_cable = GothamGame.Database.table("cable")
      db_cable.insert cables

      # Iterate Through the Cable Table
      start = new Date().getTime()
      db_cable().each (row) ->
        that.View.addCable row
      console.log "Process Cables: " + (new Date().getTime() - start) + "ms"






module.exports = WorldMapController