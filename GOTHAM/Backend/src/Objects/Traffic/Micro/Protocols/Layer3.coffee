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
      "0": "EchoReply"
      "3": "Unreachable"
      "8": "Echo"
      "11": "Timeout"
      "30": "Tracert"

    l3.returnCodes =
      "0": "NetUnreachable"
      "1": "HostUnreachable"
      "2": "ProtocolUnreachable"
      "3": "PortUnreachable"
    return l3


  @IP = ->
    l3 = new Layer3("IP")

    l3.IpVersion = 4

    return l3



module.exports = Layer3