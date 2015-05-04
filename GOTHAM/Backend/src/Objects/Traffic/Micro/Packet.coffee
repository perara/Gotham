class Packet

  constructor: (data = "", fromSource = true, ttl = 9999) ->

    @data = data
    @fromSource = fromSource
    @ttl = ttl

  @getIcmpRequest: ->
    return{

    }

module.exports = Packet