BaseLayer = require './BaseLayer.coffee'

class Layer6 extends BaseLayer

  constructor: (type) ->
    @type = type
    @hash = null
    @version = null

  @None: ->
    l6 = new Layer6("None")

    return l6

  @SSL: ->
    l6 = new Layer6("SSL")

    return l6

  @TLS: ->
    l6 = new Layer6("TLS")

    return l6

  @DTLS: ->
    l6 = new Layer6("DTLS")

    return l6

module.exports = Layer6
