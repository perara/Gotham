
# Session object containing source, target ,traffic path and packets exchanged
class Session

  constructor: (sourceHost, target, type, packets = [""]) ->
    type = if not type then "None" else type

    # Checks if target is a network or a host
    if not target.network
      @targetNetwork = target
      @targetNode = target.getNode()
    else
      @targetNetwork = target.getNetwork()
      @targetNode = target.getNetwork().getNode()

    # Set accessible variables
    @sourceNetwork = sourceHost.getNetwork()
    @sourceNode = sourceHost.getNetwork().getNode()
    @sourceHost = sourceHost
    @targetHost = target


    @path = Gotham.Micro.Pathfinder.bStar(@sourceNode, @targetNode)
    @layers = Gotham.Micro.LayerStructure.Packet[type]()
    @nodeHeaders = {}

    # Generate packet details
    @packets = @getPacketsInfo(packets)

    # For each node, get header info for each packets

    @getNodeHeaders()

    # Sets MAC and IP in default Layer Structure (template)
    @layers.L2.sourceMAC = @sourceNode.mac
    @layers.L2.destMAC = @targetNode.mac
    @layers.L3.sourceIP = @sourceNetwork.internal_ip_v4
    @layers.L3.destIP = @targetNetwork.internal_ip_v4

  getNodeHeaders: () ->
    for node in @path
      nodeHeader = []

      # Make header info for this node on each packet
      for packet in @packets
        deltaHeader = {}

        # Set source and target MAC depending on current node
        current = @path.indexOf(node)
        deltaHeader.sourceMAC = @path[current].mac
        deltaHeader.destMAC = if (current != @path.length - 1) then @path[current + 1].mac else null

        nodeHeader.push(deltaHeader)

      @nodeHeaders[node.id] = nodeHeader

  getPacketsInfo: (packets) ->
    result = []
    seqNumber = 0

    # Generate sequence numbers for each packet
    for packet in packets
      deltaPacket = {}
      deltaPacket.seqNumber = seqNumber += packet.length
      deltaPacket.data = packet
      result.push(deltaPacket)

    return result

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