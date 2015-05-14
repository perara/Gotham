class Packet

  # Generating a basic packet with data, ttl, delay
  constructor: (data = "", fromSource = true, ttl = 9999, delay = 0) ->

    @data = data
    @fromSource = fromSource
    @ttl = ttl
    @delay = delay


module.exports = Packet