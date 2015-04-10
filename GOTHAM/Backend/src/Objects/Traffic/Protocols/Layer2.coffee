class Layer2 extends BaseLayer

  constructor: (source, dest) ->
    @sourceMAC = source
    @destMAC = dest

class Ethernet extends Layer2
  setType: ->
    return "Ethernet"

class Wifi extends Layer2
  setType: ->
    return "Wifi"

module exports = Ethernet
module exports = Wifi