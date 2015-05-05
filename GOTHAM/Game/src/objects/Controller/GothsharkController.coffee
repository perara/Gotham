View = require '../View/GothsharkView.coffee'



###*
# GothsharkController is the data management of the Gothshark Application. This is a quite special controller, since gothshark is located inside index.html
# @class GothsharkController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
###
class GothsharkController extends Gotham.Pattern.MVC.Controller

  constructor : (name) ->
    super View, name

  create: ->
    @setupPacketListener()


  setupPacketListener: ->


    GothamGame.Network.Socket.on 'Session', (session) ->

      db_node = Gotham.Database.table "node"


      template = session.layers
      for node in session.path

        nodeObject = db_node.findOne(id: node)

        # Get array of diff packages
        diffArray = session.nodeHeaders[node]

        for diff in diffArray

          # Create new packet for the DIFF
          packet = JSON.parse(JSON.stringify(template))

          # Iterate over properties on the diff (L2, L3)
          for key, layer of diff
            if key == "misc"
             continue

            # Iterate over properties of the Layer (srcMAC, targetMAC)
            for prop, val of layer
              packet[key][prop] = val


          nodeObject.packets.push packet
          console.log packet["L2"]
        console.log nodeObject.packets


      currentNode = window.GothShark.getCurrentNode()
      if currentNode
        node = db_node.findOne(id: currentNode.id)
        window.GothShark.updateNode(node)




module.exports = GothsharkController

