performance = require 'performance-now'
Room = require './../Room.coffee'

###*
# PingRoom contains emitters for Ping Events
# @class PingRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class PingRoom extends Room


  define: ->
    that = @

    ###*
    # Emitter for Ping (Defined as class, but is in reality a method inside PingRoom)
    # @class Emitter_Ping
    # @submodule Backend.Emitters
    ###
    @addEvent "Ping", (packet) ->
      client = that.getClient(@id)
      that.log.info "[TerminalRoom] Ping called: " + packet

      # Resolve Values
      HEADER_SIZE = 28 #ICMP Header Size
      packetsize = if packet.packetsize then Math.min(packet.packetsize, 65507) else 56
      target = packet.target
      targetDNSResolve = packet.target # TODO DO DNS LOOKUP
      ttl = if packet.ttl then packet.ttl else 56
      quiet = if packet.quiet then packet.quiet else false
      deadline = if packet.deadline then performance() + (packet.deadline * 1000)  else false

      # Send ping start if not quiet
      if not quiet
        client.Socket.emit 'Ping_Init', "PING #{target} (#{targetDNSResolve}) #{packetsize}(#{packetsize+HEADER_SIZE}) bytes of data."

      i = 0
      start_time = performance()
      min_rtt = 1000000
      max_rtt = -100000
      avg_rtt = 0

      intervalID = setInterval(->
        i++ # Increment counter

        # Figure out how many pings to do,
        # Setting Maximum pings to 50 (between 0-50)
        # If none count is set in packet, default to 5
        # stopInterval if iterator has reached max_count
        max_count = if packet.count then Math.min(50, packet.count) else 5
        isDeadline = if !!deadline then if deadline < performance() then true else false

        if i >= max_count or isDeadline
          clearInterval(intervalID)
          client.Socket.emit 'Ping_Summary', [
            "--- #{target} ping statistics ---"
            "#{i} packets transmitted, #{i} received, 0% packet loss, time #{Math.floor(performance()-start_time)}ms"
            "rtt min/avg/max = #{min_rtt.toFixed(3)}/#{max_rtt.toFixed(3)}/#{avg_rtt.toFixed(3)} ms"
          ]
          return


        rtt = Math.random() * (60 - 50) + 50 # TODO - SUM of latency between nodes (routing)

        # Update RTT Statistics
        min_rtt = if min_rtt > rtt then rtt else min_rtt
        max_rtt = if max_rtt < rtt then rtt else max_rtt
        avg_rtt = (avg_rtt + rtt) / 2

        # Send the actual ping if not quiet
        if not quiet
         client.Socket.emit 'Ping', "#{packetsize + 8} bytes from #{targetDNSResolve}: icmp_seq=#{i} ttl=#{ttl} time=#{rtt.toFixed(3)} ms"


          , if packet.interval then packet.interval * 1000 else 1000)





module.exports = PingRoom