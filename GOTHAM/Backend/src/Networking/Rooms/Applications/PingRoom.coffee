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

      HEADER_SIZE = 28 #ICMP Header Size
      args =
        ttl: if packet.ttl then packet.ttl else 56
        packetsize: if packet.packetsize then Math.min(packet.packetsize, 65507) else 56
        deadline: if packet.deadline then performance() + (packet.deadline * 1000)  else false
        max_count: if packet.count then Math.min(50, packet.count) else 5
        interval: if packet.interval then packet.interval * 1000 else 1000

      # Get tables
      db_host = Gotham.LocalDatabase.table("Host")
      db_network = Gotham.LocalDatabase.table("Network")

      # Fetch source host
      sourceHost = db_host.findOne(id: packet.sourceHost)

      # Fetch target host
      targetNetwork = db_network.findOne(external_ip_v4: packet.target)

      # IF target does not exist
      if not targetNetwork
        client.Socket.emit "Ping_Host_Not_found", {}
        return

      # Start Solution
      session = new Gotham.Micro.Session(sourceHost, targetNetwork, "ICMP")

      # Add ICMP Ping packets
      for i in [0...args.max_count]
        session.addPacket new Gotham.Micro.Packet("8", true, args.ttl, args.interval)
        session.addPacket new Gotham.Micro.Packet("0", false, args.ttl, 0)



      client.Socket.emit "Session", session

      # Process Ping data
      skip = false # flag to skip half of the packets
      lastSkip = null
      client.Socket.emit "Ping", {
        target: packet.target
        HEADER_SIZE: HEADER_SIZE
        packetsize:  + args.packetsize
        pings: session.nodeHeaders[Object.keys(session.nodeHeaders)[0]].map((item) ->
          return {time: item.misc.time}
        ).filter (item) ->
          skip = !skip

          if skip
            lastSkip = item
            return 0

          item.rtt = item.time - lastSkip.time
          return 1


      }





module.exports = PingRoom