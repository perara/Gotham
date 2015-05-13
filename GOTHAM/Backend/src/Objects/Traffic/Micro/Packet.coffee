class Packet

  constructor: (data = "", fromSource = true, ttl = 9999, delay = 0) ->

    @data = data
    @fromSource = fromSource
    @ttl = ttl
    @delay = delay

  @getIcmpRequest: ->
    return{

    }

module.exports = Packet