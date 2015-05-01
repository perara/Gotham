
# Session object containing source, target ,traffic path and packets exchanged
class Session

  constructor: (sourceHost, targetHost, type, packets) ->
    type = if not type then "None" else type

    sourceNode = sourceHost.getNetwork().getNode()
    targetNode = targetHost.getNetwork().getNode()

    @sourceHost = sourceHost
    @targetHost = targetHost

    @path = Gotham.Micro.Pathfinder.bStar(sourceNode, targetNode)
    @layers = Gotham.Micro.LayerStructure.Packet[type]()
    @nodeHeaders = {}
    @packets = @getPacketsInfo(packets)

    console.log @packets
    # For each node, get header info for each packets
    for node in @path
      @nodeHeaders[node.id] = @getNodeHeaders(node)

  getNodeHeaders: (node) ->
    nodeHeaders = []

    # Make header info for this node on each packet
    for packet in @packets
      deltaHeader = {}

      # Set source and target MAC depending on current node
      current = @path.indexOf(node)
      deltaHeader.sourceMAC = @path[current].mac
      deltaHeader.destMAC = if (current != @path.length - 1) then @path[current + 1].mac else @path[0].mac

      nodeHeaders.push(deltaHeader)
    return nodeHeaders

  getPacketsInfo: (packets) ->
    result = []
    seqNumber = 0

    for packet in packets
      deltaPacket = {}
      deltaPacket.seqNumber = seqNumber += packet.length
      deltaPacket.data = packet
      result.push(deltaPacket)

    return result

  setData: (data) ->
    @layers["L7"].data = data

  setLayer: (layer, name) ->
    @layers[layer] = Gotham.Micro.LayerStructure.Layers[layer][name]()

  printJSON: ->
    if not @layers.IntegrityCheck() then throw new Error("Inconsistent layers")
    log.Info(JSON.stringify(this))

  printLayers: ->

    if not @layers.IntegrityCheck() then log.Error("Integrity check failed")

    log.Info("=========================================")

    log.Info("Link Layer: \t\t" + @layers.L2.type)
    log.Info("Network Layer: \t" + @layers.L3.type)
    log.Info("Transport Layer: \t" + @layers.L4.type)
    log.Info("Encryption Layer: \t" + @layers.L6.type)
    log.Info("Application Layer: \t" + @layers.L7.type)

    log.Info("=========================================")


module.exports = Session