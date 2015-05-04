BaseLayer = require './BaseLayer.coffee'

class Layer3 extends BaseLayer

  constructor: (type) ->
    @type = type
    @sourceIP = null
    @destIP = null

  @ICMP = ->
    l3 = new Layer3("ICMP")
    l3.delay = 0
    l3.code = null
    l3.returnCode = null


    l3.messages =
      EchoReply: 0
      Unreachable: 3
      Echo: 8
      Timeout: 11
      Tracert: 30

    l3.returnCodes =
      NetUnreachable: 0
      HostUnreachable: 1
      ProtocolUnreachable: 2
      PortUnreachable: 3
    return l3


  @IP = ->
    l3 = new Layer3("IP")

    l3.IpVersion = 4

    return l3



module.exports = Layer3