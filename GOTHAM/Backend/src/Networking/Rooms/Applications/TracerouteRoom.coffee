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
    @addEvent "Traceroute", (packet) ->
      client = that.getClient(@id)

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

      # Get nodes for source and target
      sourceNode = sourceHost.getNetwork().getNode()
      targetNode = targetNetwork.getNode()




      # Calculate solution
      solution = Traffic.Pathfinder.bStar(sourceNode, targetNode, 2, 3)

      # Make session for this traceroute
      ttl = 1
      packets = []
      for i in solution.length
        packets.push("", true, ttl)
        packets.push("", false)
      session = new Traffic.Session(sourceHost, targetNetwork, "ICMP")




      #client.Socket.emit 'Session', session

      # TODO LOL - Output path
      outputarr = []
      outputarr.push ("=======================================")
      outputarr.push ("Path of nodes (#{solution.length}):")
      outputarr.push ("---------------------------------------")
      for node in solution
        outputarr.push (node.id + " - " +node.name)
      outputarr.push ("=======================================")

      client.Socket.emit 'Traceroute', Traffic.Pathfinder.toIdList(solution), outputarr, JSON.prune(targetNetwork)






module.exports = TracerouteRoom