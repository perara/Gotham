log = require('log4js').getLogger("LayerStructure")
Protocols = require './Protocols/Protocols.coffee'


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

  @Layers =
    L2:
      WIFI: Protocols.Layer2.WIFI
      Ethernet: Protocols.Layer2.Ethernet
    L3:
      ICMP: Protocols.Layer3.ICMP
      IP: Protocols.Layer3.IP
    L4:
      TCP: Protocols.Layer4.TCP
      UDP: Protocols.Layer4.UDP
    L6:
      None: Protocols.Layer6.None
      SSL: Protocols.Layer6.SSL
      TLS: Protocols.Layer6.TLS
      DTLS: Protocols.Layer6.DTLS
    L7:
      HTTP: Protocols.Layer7.HTTP
      FTP: Protocols.Layer7.FTP
      DNS: Protocols.Layer7.DNS
      HTTPS: Protocols.Layer7.HTTPS
      SFTP: Protocols.Layer7.SFTP
      SSH: Protocols.Layer7.SSH


  @Packet =
    ICMP: ->
      return {
        L2: LayerStructure.Layers.L2.Ethernet()
        L3: LayerStructure.Layers.L3.ICMP()
        }

    HTTP: ->
      return {
        L2: LayerStructure.Layers.L2.Ethernet()
        L3: LayerStructure.Layers.L3.IP()
        L4: LayerStructure.Layers.L4.TCP()
        L6: LayerStructure.Layers.L6.None()
        L7: LayerStructure.Layers.L7.HTTP()
      }

    HTTPS: ->
      return {
        L2: LayerStructure.Layers.L2.Ethernet()
        L3: LayerStructure.Layers.L3.IP()
        L4: LayerStructure.Layers.L4.TCP()
        L6: LayerStructure.Layers.L6.TLS()
        L7: LayerStructure.Layers.L7.HTTPS()
      }

module.exports = LayerStructure
