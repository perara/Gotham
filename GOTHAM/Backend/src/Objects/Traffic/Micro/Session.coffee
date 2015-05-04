
# Session object containing source, target ,traffic path and packets exchanged
class Session

  constructor: (sourceHost, targetNetwork, type, packets = [""]) ->
    type = if not type then "None" else type

    # Set source variables
    @sourceNetwork = sourceHost.getNetwork()
    @sourceNode = sourceHost.getNetwork().getNode()
    @sourceHost = sourceHost

    # Set target variables
    @targetNetwork = targetNetwork
    @targetNode = targetNetwork.getNode()
    @target = targetNetwork



    @path = Gotham.Micro.Pathfinder.bStar(@sourceNode, @targetNode)
    console.log type
    @layers = Gotham.Micro.LayerStructure.Packet[type]()
    console.log @layers
    @nodeHeaders = {}

    # Generate packet details
    @packets = @getPacketsInfo(packets)

    # For each node, get header info for each packets

    @getNodeHeaders()

    # Sets MAC and IP in default Layer Structure (template)
    @layers.L2.sourceMAC = @sourceNetwork.mac
    @layers.L2.destMAC = @targetNetwork.mac
    @layers.L3.sourceIP = @sourceNetwork.internal_ip_v4
    @layers.L3.destIP = @targetNetwork.internal_ip_v4


  getNodeHeaders: () ->
    time = 0

    for node in @path
      #nodeHeader = []
      deltaHeader = {}
      deltaHeader.L2 = {}
      deltaHeader.misc = {}


      # Set source and target MAC depending on current node
      current = @path.indexOf(node)
      deltaHeader.L2.sourceMAC = @path[current].getNetwork().mac
      deltaHeader.L2.destMAC = if (current != @path.length - 1) then @path[current + 1].getNetwork().mac else null

      # Set time
      deltaHeader.misc.time = time += @layers.L3.delay
      console.log time

      #nodeHeader.push(deltaHeader)

      @nodeHeaders[node.id] = deltaHeader

  getPacketsInfo: (packets) ->
    result = []
    seqNumber = 0

    # Is this TCP (then SYN ACK)
    if @layers.L3.type == "TCP"
      deltaSyn = {}
      deltaSynAck = {}
      deltaSyn.SYN = 1
      deltaSynAck.SYN = deltaSynAck.ACK = 1
      result.push(deltaSyn)
      result.push(deltaSynAck)

    # Generate sequence numbers for each packet
    for packet in packets
      deltaPacket = {}
      deltaPacket.SEQ = seqNumber += packet.length
      deltaPacket.data = packet
      result.push(deltaPacket)

      # If TCP then send ACK too
      if @layers.L3.type == "TCP"
        deltaPacket = {}
        deltaPacket.ACK = seqNumber
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

  setPorts: (source, target = source) ->
      @layers.L4.sourcePort = source
      @layers.L4.targetPort = target

  setJumpDelay: (delay) ->
    @layers.L3.delay = delay
    @getNodeHeaders()

  toJSON: ->
    return {
      sourceNetwork: @sourceNetwork.id
      sourceHost: @sourceHost.id
      targetNetwork: @targetNetwork.id
      path: @path.map (node) -> return node.id
      packets: @packets
      layers : @layers
      nodeHeaders: @nodeHeaders

    }


module.exports = Session