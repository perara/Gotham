View = require '../View/GothsharkView.coffee'



###*
# GothsharkController is the data management of the Gothshark Application. This is a quite special controller, since gothshark is located inside index.html
# @class GothsharkController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class GothsharkController extends Gotham.Pattern.MVC.Controller

  constructor : (name) ->
    super View, name

  create: ->
    @setupPacketListener()
    @processPacket()


  setupPacketListener: ->
    that = @

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

        # Process the packet data
        processedPacket = processPacket(packet)

        # Add the processed packet to the packet array
        nodeObject.packets.push processedPacket

      @redraw()


  ###*
  # Redraws the node gothshark view with current node
  # @method redraw
  ###
  redraw: ->
    if @currentNode
      @showNode(@currentNode)


  showNode: (node) ->
    # Set currentNode
    @currentNode = node

    # Clear the table
    @View.clearTable()

    # Add all of the packets
    for packet in node.packets
      @View.addPacket(packet)




  processPacket: (packet) ->
    # TODO
    obj = {
      number: "1"
      time: "lol"
      source: "10.0.0.1"
      dest: "10.0.0.2"
      protocol: "11001"
      length: "10"
      info: "Some info"
    }
    return obj




module.exports = GothsharkController

