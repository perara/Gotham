
# Session object containing source, target ,traffic path and packets exchanged
class Session

  constructor: (sourceHost, targetNetwork, type, customPath, blacklist) ->
    type = if not type then "None" else type

    # Set source variables
    @sourceNetwork = sourceHost.getNetwork()
    @sourceNode = sourceHost.getNetwork().getNode()
    @sourceHost = sourceHost

    # Set target variables
    @targetNetwork = targetNetwork
    @targetNode = targetNetwork.getNode()
    @target = targetNetwork

    if customPath
      @path = customPath
    else
      @path = Gotham.Micro.Pathfinder.bStar(@sourceNode, @targetNode, blacklist)
    @reversePath = [].concat(@path)

    @layers = Gotham.Micro.LayerStructure.Packet[type]()
    @nodeHeaders = {}
    @packets = []

    # Sets MAC and IP in default Layer Structure (template)
    @layers.L2.sourceMAC = @sourceNode.getNetwork().mac
    @layers.L2.destMAC = @targetNetwork.mac
    @layers.L3.sourceIP = @sourceNetwork.internal_ip_v4
    @layers.L3.destIP = @targetNetwork.internal_ip_v4

    return @

  getPath: ->
    return @path

  addPacket: (packet) ->
    @packets.push packet
    @getNodeHeaders()
    @calculateDelay()
    return @

  getNodeHeaders: () ->
    time = 0
    @nodeHeaders = {}
    deltaTime = 0

    for index in [0...@path.length]
      node = @path[index]
      nodeHeader = []
      seq = 0


      for packet in @packets

        # If time to live is less than node index, this packet should die
        if packet.ttl <= index
          continue

        deltaHeader = {}
        deltaHeader.L2 = {}
        deltaHeader.L3 = {}

        deltaHeader.misc = {}

        # Set source and target MAC depending on current node
        # If sending packet to target
        if packet.fromSource
          deltaHeader.L2.sourceMAC = if (index != @path.length - 1) then @path[index].getNetwork().mac else @path[index - 1].getNetwork().mac
          deltaHeader.L2.destMAC = if (index != @path.length - 1) then @path[index + 1].getNetwork().mac else @path[index].getNetwork().mac

        # If receiving packet from target
        else
          deltaHeader.L2.sourceMAC = if (index != 0) then @path[index].getNetwork().mac else @path[index + 1].getNetwork().mac
          deltaHeader.L2.destMAC = if (index != 0) then @path[index - 1].getNetwork().mac else @path[index].getNetwork().mac

        # Set time
        deltaHeader.misc.packetNr = @packets.indexOf(packet)

        # Checking if this is a 3 or a 7 layer session
        if not @layers.L4
          deltaHeader.L3.code = packet.data
          deltaHeader.L3.ttl = packet.ttl
          nodeHeader.push(deltaHeader)
          continue

        # If this is a TCP packet, sequence numbers are needed
        if @layers.L4.type == "TCP"
          deltaHeader.L3.seq = seq += packet.data.length

        # Set package info
        deltaHeader.L7 = {}
        deltaHeader.L7.data = packet.data


        nodeHeader.push(deltaHeader)

      @nodeHeaders[node.id] = nodeHeader

  getPacketsInfo: () ->
    result = []
    seqNumber = 0
    totalDelay = 0

    # Is this TCP (then SYN ACK)
    if @layers.L3.type == "TCP"
      deltaSyn = {}
      deltaSynAck = {}
      deltaSyn.SYN = 1
      deltaSynAck.SYN = deltaSynAck.ACK = 1
      result.push(deltaSyn)
      result.push(deltaSynAck)

    # Generate sequence numbers for each packet and calculate deltaTime for delayed packets
    for packet in @packets
      newPacket = {}
      newPacket.SEQ = seqNumber += packet.length
      newPacket.data = packet

      # If TCP then send ACK too
      if @layers.L3.type == "TCP"
        deltaPacket = {}
        deltaPacket.ACK = seqNumber
        result.push(deltaPacket)

    return result

  calculateDelay: ->
    totalDelay = 0
    deltaTime = 0

    for packet in @packets
      totalDelay += packet.delay
      path = if packet.fromSource then @path else @reversePath

      for index in [0...path.length]
        if not @nodeHeaders[path[index].id][@packets.indexOf(packet)] then continue
        if not @nodeHeaders[path[index].id][@packets.indexOf(packet)].misc.packetNr == @packets.indexOf(packet) then continue
        deltaTime += if index == path.length - 1 then 0 else Gotham.Util.GeoTool.getLatency(path[index], path[index + 1])
        @nodeHeaders[path[index].id][@packets.indexOf(packet)].misc.time = totalDelay + deltaTime


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