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
    # Clear node container (Else risking memory leak)
    @View.clearNodeContainer()

    @createHost()
    @createNodes()
    @createCables()

    @setupIPViking()
    @emitNodeLoad()
    @emitClock()

    @currentMinutes = 0

  createNodes: ->
    that = @

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
    that = @
    GothamGame.Network.Socket.on 'NetworkPurchaseUpdate', (network) ->
      gNetworkNode = that.View.addNetwork(network)
      gNetworkNode.bringToBack()

    db_user = Gotham.Database.table('user')
    user = db_user.find()[0]

    for identity in user.Identities
      for network in identity.Networks
          @View.addNetwork(network)

    return
  ###*
  # Create a emit listener NodeLoad
  # This stream is relayed from main server
  # Emitter: NodeLoadUpdate
  # @method emitNodeLoad
  ###
  emitNodeLoad: ->
    that = @

    db_node = Gotham.Database.table("node")

    GothamGame.Network.Socket.on 'NodeLoadUpdate', (json) ->


      for id, load of json
        node = db_node.findOne(id: parseInt(id))
        node.time = ((node.lng + 180) / 0.25) + that.currentMinutes

        node.loadColor = GothamGame.Tools.ColorUtil.getColorForPercentage(load)

        if node.sprite.infoFrame
          node.sprite.infoFrame.nodeLoad.text = "Load: #{(load*100).toFixed(2)}"


        # Calculate time
        utc = moment().utcOffset('+0000')
        utc.subtract(utc.hours(), "hours")
        utc.minutes(utc.minutes(), "minutes")
        utc.add(12, 'hours')
        nowthen = utc.add(node.time, "minutes")

        if node.sprite.infoFrame
          node.sprite.infoFrame.nodeTime.text = "Time: #{nowthen.format('H:mm')}"

        node.sprite.tint = node.loadColor

  ###*
  # Create a emit for World Clock
  # @method emitClock
  ###
  emitClock: ->
    that = @
    maxTime = 1440

    GothamGame.Network.Socket.on 'World_Clock', (data) ->
      that.currentMinutes = data.minutes
      current = ((data.minutes / maxTime) * (180 * 2) - 180) * -1


      position = that.View.coordinateToPixel(10, current)
      that.View.sun.visible = true
      that.View.sun.x = position.x








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


      if Gotham.Running and GothamGame.Globals.showAttacks == true
        that.View.animateAttack source, target







module.exports = WorldMapController