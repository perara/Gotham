class Layer3 extends BaseLayer

  constructor: (sourceIP, targetIP) ->
    @sourceIP = sourceIP
    @targetIP = targetIP


class ICMP extends Layer3
  IcmpTypes =
    EchoReply: 0
    Unreachable: 3
    Echo: 8
    Timeout: 11
    Tracert: 30

  IcmpCodes =
    NetUnreachable: 0
    HostUnreachable: 1
    ProtocolUnreachable: 2
    PortUnreachable: 3

  constructor: (type, code, message) ->
    @IcmpType = type
    @IcmpCode = code
    @Message = message

  type = "ICMP"
  setType: ->
    return "ICMP"

class IP extends Layer3

  @IpVersion = null

  setType: ->
    return "IP"

module.exports = ICMP
module.exports = IP