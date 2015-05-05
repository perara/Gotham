View = require '../View/WorldMapView.coffee'


###*
# World map controller manages all events inside the WorldMap. Hosts, Cables, Nodes, IPViking
# @class WorldMapController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller

###
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

    for node in db_node.find()
      node.packets = []
      that.View.addNode node, true

    console.log "Process Nodes: " + (new Date().getTime() - start) + "ms"

  createCables: ->
    that = @

    # Insert cables into -the "cables" table
    db_cable = Gotham.Database.table("cable")

    # Iterate Through the Cable Table
    start = new Date().getTime()
    for cable in db_cable.find()
      that.View.addCable cable
    console.log "Process Cables: " + (new Date().getTime() - start) + "ms"

  createHost: ->

    db_user = Gotham.Database.table('user')
    user = db_user.find()[0]

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


      if Gotham.Running
        that.View.animateAttack source, target







module.exports = WorldMapController