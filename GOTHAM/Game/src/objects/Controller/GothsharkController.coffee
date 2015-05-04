View = require '../View/GothsharkView.coffee'


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



        packet = jQuery.extend({}, template)

        diffData = session.nodeHeaders[node]

        for key, layer of diffData
          if key == "misc"
            continue

          for prop, val of layer
            packet[key][prop] = val

        nodeObject.packets.push packet

        console.log packet
      currentNode = window.GothShark.getCurrentNode()
      if currentNode
        node = db_node.findOne(id: currentNode.id)
        window.GothShark.updateNode(node)




module.exports = GothsharkController

