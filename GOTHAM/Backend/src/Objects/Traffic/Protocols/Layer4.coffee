BaseLayer = require './BaseLayer.coffee'

class Layer4 extends BaseLayer

  constructor: (source, dest) ->
    @sourceMAC = source
    @destMAC = dest

class TCP extends Layer4
  setType: ->
    return "TCP"

class UDP extends Layer4
  setType: ->
    return "UDP"

module.exports = TCP
module.exports = UDP