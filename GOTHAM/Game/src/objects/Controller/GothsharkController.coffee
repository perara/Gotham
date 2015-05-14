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


  setupPacketListener: ->
    that = @

    GothamGame.Network.Socket.on 'Session', (session) ->
      db_node = Gotham.Database.table "node"

      template = session.layers

      for node in session.path
        nodeObject = db_node.findOne(id: node)

        diffData = session.nodeHeaders[node]


        for i in [0...diffData.length]
          diff = diffData[i]

          packet = jQuery.extend({}, template)

          for layerNum, layer of diff
            if layerNum == "misc"
              packet[layerNum] = layer
              continue

            for prop, val of layer
              packet[layerNum][prop] = val
              packet["L7"] =
                data: session.packets[i].data


          processedPacket = that.processPacket(packet, nodeObject.packets.length + 1)

          # Add the processed packet to the packet array
          nodeObject.packets.push processedPacket




      that.redraw()


  ###*
  # Redraws the node gothshark view with current node
  # @method redraw
  ###
  redraw: ->
    if @currentNode
      @setNode(@currentNode)


  setNode: (node) ->
    # Set currentNode
    @currentNode = node

    # Clear the table
    @View.clearTable()

    @View.setNode({
      name: node.name
      ip: node.Network.external_ip_v4
    })

    # Add all of the packets
    for packet in node.packets
      @View.addPacket(packet)




  ###*
  # Processed the packet information to a readable wireshark row
  # @method processPacket
  # @param packet {Object} The raw packet information
  # @param number {Number} Numbering
  ###
  processPacket: (packet, number) ->
    processedPacket =
      number: null
      time: null
      source: null
      dest: null
      protocol: null
      length: null
      info: null


    # Check which type this packet is (L3)
    if packet.L3.type == "ICMP"

      if packet.L3.code == "0"
        type = "Echo (ping) Reply"
      else if packet.L3.code == "8"
        type = "Echo (ping) Request"

      processedPacket["length"] =  74
      processedPacket.info = "#{type}   src=#{packet.L2.sourceMAC} dest=#{packet.L2.destMAC} ttl=#{packet.L3.ttl}"


    processedPacket.number = ""+number
    processedPacket.time = packet.misc.time

    processedPacket.source = ""+packet.L3.sourceIP
    processedPacket.dest = ""+packet.L3.destIP
    processedPacket.protocol = ""+packet.L3.type

    return processedPacket




module.exports = GothsharkController

