Room = require './Room.coffee'




class TerminalRoom extends Room


  define: ->
    that = @

    @AddEvent "Ping", (data) ->
      client = that.GetClient(@id)
      that.log.info "[TerminalRoom] Ping called" + data

      numPings = 10

      output = ["PING #{data.address} (#{data.address}) 56(84) bytes of data."]
      for i in [0...numPings]
        rtt = Math.random() * (60 - 40) + 40; # TODO , this should be based of node delay
        out = "64 bytes from #{data.address} (#{data.address}): icmp_seq="+i+" ttl=246 time=#{rtt} ms"
        output.push(out)

      console.log output
      client.Socket.emit 'Ping', output





module.exports = TerminalRoom