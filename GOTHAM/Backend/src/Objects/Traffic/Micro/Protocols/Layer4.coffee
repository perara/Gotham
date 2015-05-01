BaseLayer = require './BaseLayer.coffee'

class Layer4 extends BaseLayer

  constructor: (type) ->
    @type = type
    @sourcePort = null
    @targetPort = null
    @ttl = null
    @length = null

  @TCP = ->
    l4 = new Layer4("TCP")
    l4.seqNumber = null
    l4.ackNumber = null
    l4.segLength = null

    return l4

  @UDP = ->
    l4 = new Layer4("UDP")

    return l4


module.exports = Layer4