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
      database = new Database()


      promises = []

      # Host object
      sourceNode = null
      targetNetwork = targetNetwork
      targetNode = null


      # Fetch source Node
      promises.push database.Model.Host.findOne(
        where: id: packet.sourceHost
        include: [
          {
            model: database.Model.Network
            include: [
              {
                model : database.Model.Node
                include: [ database.Model.Cable]
              }
            ]
          }
        ]
      ).then (_host) ->
        sourceNode = _host.Network.Node

      # Fetch Target Node
      promises.push database.Model.Network.findOne(
        where: external_ip_v4: packet.target
        include: [
          {
            model : database.Model.Node
            include: [ database.Model.Cable]
          }
        ]
      ).then (network) ->
        targetNetwork = network
        targetNode = network.Node




      # When all database lookup is done
      When.all(promises).then(->


        session = new Gotham.Micro.Session(host1, host2, "ICMP")
        session.L3.ICMP.code = 8
        solution = Traffic.Pathfinder.bStar(sourceNode, targetNode)


        # TODO LOL
        outputarr = []
        outputarr.push ("=======================================")
        outputarr.push ("Path of nodes (#{solution.length}):")
        outputarr.push ("---------------------------------------")
        for node in solution
          outputarr.push (node.id + " - " +node.name)
        outputarr.push ("=======================================")

        client.Socket.emit 'Traceroute', Traffic.Pathfinder.toIdList(solution), outputarr, targetNetwork


      )






module.exports = TracerouteRoom