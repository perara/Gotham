class LayerStructure

  constructor: (layer2 = null, layer3 = null, layer4 = null, layer6 = null, layer7 = null) ->
    @layers =
      L2: layer2
      L3: layer3
      L4: layer4
      L6: layer6
      L7: layer7

  IntegrityCheck: ->

    layerEnd = false;

    for layer in this
      if (layer != null && layerEnd)
        log.Error("Integrity check failed");
        return false;

      else if (layer == null)
        layerEnd = true;

    return true;

  Ethernet: -> @layers.L2 = Ethernet
  Wifi: -> @layers.L2 = Wifi
  ICMP: -> @layers.L2 = ICMP
  IP: -> @layers.L2 = IP
  TCP: -> @layers.L2 = TCP
  UDP: -> @layers.L2 = UDP
  TCP: -> @layers.L2 = TCP
  UDP: -> @layers.L2 = UDP

  MakeICMP: ->
    @layers.L2 = Ethernet
    @layers.L3 = ICMP

  MakeHTTP: ->
    @layers.L2 = Ethernet
    @layers.L3 = IP
    @layers.L4 = TCP
    @layers.L6 = NoEncryption
    @layers.L7 = HTTP

  MakeHTTPS: ->
    @layers.L2 = Ethernet
    @layers.L3 = IP
    @layers.L4 = TCP
    @layers.L6 = TLS
    @layers.L7 = HTTPS


