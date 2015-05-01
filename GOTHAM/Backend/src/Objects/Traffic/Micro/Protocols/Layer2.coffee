BaseLayer = require './BaseLayer.coffee'

class Layer2 extends BaseLayer

  constructor: (type) ->
    @type = type
    @sourceMAC = null
    @destMAC = null

  @Ethernet = ->
    l2 = new Layer2("Ethernet")

    return l2

  @WIFI = ->
    l2 = new Layer2("WIFI")

    return l2




module.exports = Layer2