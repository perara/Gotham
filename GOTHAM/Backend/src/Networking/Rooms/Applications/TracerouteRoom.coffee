performance = require 'performance-now'
When = require 'when'
Room = require './../Room.coffee'
Database = require '../../../Database/Database.coffee'
Traffic = require '../../../Objects/Traffic/Micro/Micro.coffee'

###*
# TracerouteRoom contains emitters for any traceroute events
# @class TracerouteRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class TracerouteRoom extends Room


  define: ->
    that = @

    ###*
    # Emitter for Traceroute (Defined as class, but is in reality a method inside TracerouteRoom)
    # @class Emitter_Traceroute
    # @submodule Backend.Emitters
    ###
    @addEvent "Traceroute", (packet, blacklist) ->
      client = that.getClient(@id)

      # Data format is
      # {node: id}
      # Transform to:
      # [id,id,id}
      db_node = Gotham.LocalDatabase.table("Node")
      blacklist = blacklist.map (obj) ->
        return db_node.findOne(id: obj.node)

      # Get tables
      db_host = Gotham.LocalDatabase.table("Host")
      db_network = Gotham.LocalDatabase.table("Network")

      # Fetch source host
      sourceHost = db_host.findOne(id: packet.sourceHost)

      # Fetch target host
      targetNetwork = db_network.findOne(external_ip_v4: packet.target)


      # SourceHost does not exist
      if not sourceHost
        client.Socket.emit 'TracerouteRoom_Error', "ERROR_NO_SOURCE_HOST" #TODO
        return

      # TargetNetwork does not exist
      if not targetNetwork
        client.Socket.emit 'TracerouteRoom_Error', "ERROR_NO_TARGET_HOST" #TODO
        return


      # Start Solution
      session = new Gotham.Micro.Session(sourceHost, targetNetwork, "ICMP", false, blacklist)

      if session.getPath() == null
        return


      # Make session for this traceroute
      for ttl in [1...(session.getPath().length + 1)]
        session.addPacket new Gotham.Micro.Packet("8", true, ttl)
        session.addPacket new Gotham.Micro.Packet("0", false, ttl)


      client.Socket.emit 'Session', session

      # TODO LOL - Output path
      outputarr = []

      for node in session.getPath()
        outputarr.push (node.id + " - " +node.name)

      client.Socket.emit 'Traceroute', Traffic.Pathfinder.toIdList(session.getPath()), outputarr, JSON.prune(targetNetwork)






module.exports = TracerouteRoom