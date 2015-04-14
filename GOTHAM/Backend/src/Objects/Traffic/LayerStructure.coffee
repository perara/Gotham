Traffic = require './Traffic.coffee'

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

  # Set layer 2 functions
  Ethernet: -> @layers.L2 = Traffic.Protocols.Layer2.Ethernet
  Wifi: -> @layers.L2 = Traffic.Protocols.Layer2.Wifi

  # Set layer 3 functions
  ICMP: -> @layers.L2 = Traffic.Protocols.Layer3.ICMP
  IP: -> @layers.L2 = Traffic.Protocols.Layer3.IP

  # Set layer 4 functions
  TCP: -> @layers.L2 = Traffic.Protocols.Layer4.TCP
  UDP: -> @layers.L2 = Traffic.Protocols.Layer4.UDP

  # Set layer 6 functions
  NoEncryption: -> @layers.L2 = Traffic.Protocols.Layer6.NoEncryption
  SSL: -> @layers.L2 = Traffic.Protocols.Layer6.SSL
  TLS: -> @layers.L2 = Traffic.Protocols.Layer6.TLS
  DTLS: -> @layers.L2 = Traffic.Protocols.Layer6.DTLS

  # Set layer 7 functions
  HTTP: -> @layers.L2 = Traffic.Protocols.Layer7.HTTP
  FTP: -> @layers.L2 = Traffic.Protocols.Layer7.FTP
  DNS: -> @layers.L2 = Traffic.Protocols.Layer7.DNS
  HTTPS: -> @layers.L2 = Traffic.Protocols.Layer7.HTTPS
  SFTP: -> @layers.L2 = Traffic.Protocols.Layer7.SFTP
  SSH: -> @layers.L2 = Traffic.Protocols.Layer7.SSH


  # Predefined structures
  MakeICMP: ->
    @layers.L2 = Traffic.Protocols.Layer2.Ethernet
    @layers.L3 = Traffic.Protocols.Layer2.ICMP

  MakeHTTP: ->
    @layers.L2 = Traffic.Protocols.Layer2.Ethernet
    @layers.L3 = Traffic.Protocols.Layer3.IP
    @layers.L4 = Traffic.Protocols.Layer4.TCP
    @layers.L6 = Traffic.Protocols.Layer6.NoEncryption
    @layers.L7 = Traffic.Protocols.Layer7.HTTP

  MakeHTTPS: ->
    @layers.L2 = Traffic.Protocols.Layer2.Ethernet
    @layers.L3 = Traffic.Protocols.Layer3.IP
    @layers.L4 = Traffic.Protocols.Layer4.TCP
    @layers.L6 = Traffic.Protocols.Layer6.TLS
    @layers.L7 = Traffic.Protocols.Layer7.HTTPS

module.exports = LayerStructure
