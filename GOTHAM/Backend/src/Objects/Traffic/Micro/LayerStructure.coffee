log = require('log4js').getLogger("LayerStructure")

class LayerStructure

  constructor: (layer2 = null, layer3 = null, layer4 = null, layer6 = null, layer7 = null) ->
    @layers =
      L2: layer2
      L3: layer3
      L4: layer4
      L6: layer6
      L7: layer7

    return this


  integrityCheck: ->

    layerEnd = false;

    for layer in this
      if (layer != null && layerEnd)
        log.Error("Integrity check failed");
        return false;

      else if (layer == null)
        layerEnd = true;

    return true;


  # Set layer 2 functions
  ethernet: -> @layers.L2 = Gotham.Micro.Protocols.Layer2.Ethernet
  wifi: -> @layers.L2 = Gotham.Micro.Protocols.Layer2.Wifi

  # Set layer 3 functions
  ICMP: -> @layers.L2 = Gotham.Micro.Protocols.Layer3.ICMP
  IP: -> @layers.L2 = Gotham.Micro.Protocols.Layer3.IP

  # Set layer 4 functions
  TCP: -> @layers.L2 = Gotham.Micro.Protocols.Layer4.TCP
  UDP: -> @layers.L2 = Gotham.Micro.Protocols.Layer4.UDP

  # Set layer 6 functions
  noEncryption: -> @layers.L2 = Gotham.Micro.Protocols.Layer6.noEncryption
  SSL: -> @layers.L2 = Gotham.Micro.Protocols.Layer6.SSL
  TLS: -> @layers.L2 = Gotham.Micro.Protocols.Layer6.TLS
  DTLS: -> @layers.L2 = Gotham.Micro.Protocols.Layer6.DTLS

  # Set layer 7 functions
  HTTP: -> @layers.L2 = Gotham.Micro.Protocols.Layer7.HTTP
  FTP: -> @layers.L2 = Gotham.Micro.Protocols.Layer7.FTP
  DNS: -> @layers.L2 = Gotham.Micro.Protocols.Layer7.DNS
  HTTPS: -> @layers.L2 = Gotham.Micro.Protocols.Layer7.HTTPS
  SFTP: -> @layers.L2 = Gotham.Micro.Protocols.Layer7.SFTP
  SSH: -> @layers.L2 = Gotham.Micro.Protocols.Layer7.SSH

  # Predefined structures
  makeICMP: ->
    @layers.L2 = Gotham.Micro.Protocols.Layer2.ethernet
    @layers.L3 = Gotham.Micro.Protocols.Layer2.ICMP
    return this

  makeHTTP: ->
    @layers.L2 = Gotham.Micro.Protocols.Layer2.ethernet
    @layers.L3 = Gotham.Micro.Protocols.Layer3.IP
    @layers.L4 = Gotham.Micro.Protocols.Layer4.TCP
    @layers.L6 = Gotham.Micro.Protocols.Layer6.noEncryption
    @layers.L7 = Gotham.Micro.Protocols.Layer7.HTTP
    return this

  makeHTTPS: ->
    @layers.L2 = Gotham.Micro.Protocols.Layer2.ethernet
    @layers.L3 = Gotham.Micro.Protocols.Layer3.IP
    @layers.L4 = Gotham.Micro.Protocols.Layer4.TCP
    @layers.L6 = Gotham.Micro.Protocols.Layer6.TLS
    @layers.L7 = Gotham.Micro.Protocols.Layer7.HTTPS
    return this

module.exports = LayerStructure
