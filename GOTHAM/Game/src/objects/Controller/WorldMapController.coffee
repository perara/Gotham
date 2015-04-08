View = require '../View/WorldMapView.coffee'


class WorldMapController extends Gotham.Pattern.MVC.Controller


  constructor: (name) ->
    super View, name

  create: ->
    @create_nodes()


  create_nodes: ->
    that = @

    # This callback returns a array with nodes from the server. These nodes should be processed by the WorldMap
    # A function which places these nodes must be used.
    GothamGame.network.getJSON "/api/Node" , (data) ->

      # Insert the nodes into the "node" table
      db_node = GothamGame.Database.table("node")
      db_node.insert data.nodes

      # Insert cables into the "cables" table
      db_cable = GothamGame.Database.table("cable")
      db_cable.insert data.cables


      # Iterate Through the Cable Table
      start = new Date().getTime()
      db_cable().each (row) ->
        that.View.addCable row
      console.log "Process Cables: " + (new Date().getTime() - start) + "ms"

      # Iterate Through the Node Table
      start = new Date().getTime()
      db_node().each (row) ->
        that.View.addNode row
      console.log "Process Nodes: " + (new Date().getTime() - start) + "ms"



      """
      _cableTask = ->
        db_row = db_temp {name: "cableTask"}
        row = db_row.first()
        that.View.addCable row.cables.pop()

        if row.cables.length < 1
          return false
        else
          return true
      Gotham.GameLoop.addTask _cableTask
      """









module.exports = WorldMapController