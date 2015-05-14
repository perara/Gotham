Application = require './Application.coffee'



###*
# Application which simulates Traceroute from the Unix platform
# @class Traceroute
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class Traceroute extends Application
  @Command = "traceroute"

  constructor: (command) ->
    super command

    @Packet =
      sourceHost: null #ID of the sending host
      target: null
      algorithm: "b*"
      max_ttl: 30
      first_ttl: 1


  switches: ->
    that = @
    return [

      # Help
      ['-h', '--help', 'Show Help', ->
        that.Console.addArray @toString().split("\n")
        that.Packet = {}
      ]

      # [CUSTOM] Algorithm
      ['-a', '--algorithm STRING', 'Choose algorithm to use, Default: b*', (key, val)->
        if val?
          that.Packet.algorithm = val
        else
          that.Console.add "Available Algorithms: [a*, b*, brutus]"
      ]

      # [REAL] Max HOP (TTL)
      ['-m', '--max-hops max_ttl', 'Specifies the maximum number of hops (max time-to-live value) traceroute will probe. The default is 30.', (key, val)->
        if val?
          that.Packet.max_ttl = val
      ]

      # [REAL] First TTL
      ['-f', '--first first_ttl', 'Specifies with what TTL to start. Defaults to 1.', (key, val)->
        if val?
          that.Packet.first_ttl = val
      ]

      # Version
      ['-V', '--version', 'Show version number', (key, val)->
        that.Console.add "traceroute utility, traceroute.v01501-GOTHAM"
      ]
    ]


  execute: ->
    that = @
    parser = @ArgumentParser()

    ##############
    ## IP Argument
    ## Either last or first. ping [ip]? args [ip]?
    ##############
    ipCallback = (ipHost) ->
      if GothamGame.Tools.HostUtils.validIPHost(ipHost)
        that.Packet.target = ipHost
      else
        that.Console.add "#{that.Command}: unknown host: #{ipHost}"

    parser.on(->that.Console.addArray @toString().split("\n"))
    parser.on 0, ipCallback
    parser.on @Arguments.length, ipCallback


    # Host ID - Which should resolve to Host IP
    @Packet.sourceHost = @_commandObject.controller.host.id

    # Parse arguments
    parser.parse(@Arguments)

    # Send Traceroute request
    GothamGame.Network.Socket.emit 'Traceroute', @Packet, Gotham.Database.table("blacklist").data

    # Emit to MissionEngine
    GothamGame.MissionEngine.emit "Traceroute", @Packet.target, (req) ->
      GothamGame.Announce.message "#{req._mission._title}\n#{req._requirement} --> #{req._current}/#{req._expected}", "MISSION", 50

    # Traceroute Callback
    GothamGame.Network.Socket.on 'Traceroute', (path, output, targetNetwork) ->
      @removeListener('Traceroute')

      # Parse Target Network JSON
      targetNetwork = JSON.parse(targetNetwork)


      # Send Missio EMIT
      GothamGame.MissionEngine.emit 'traceroute', targetNetwork.external_ip_v4, ->
        console.log "Traceroute emit registererd. setting to completed!"

      # Clear old Traceroute paths
      GothamGame.Renderer.getScene("World").getObject("WorldMap").View.clearAnimatePath()



      # Fetch all Nodes
      db_node = Gotham.Database.table("node")

      # The Host Location (Source host)
      last = that._commandObject.controller.network
      hopCount = 1

      # Print the local network hop
      that.Console.add "traceroute to #{targetNetwork.external_ip_v4} (#{targetNetwork.external_ip_v4}), 30 hops max, 60 byte packets"
      that.Console.add(" #{hopCount++}  #{last.internal_ip_v4} (#{last.internal_ip_v4})")

      for nodeID in path

        # Find the node in the database
        current = db_node.findOne({id: nodeID})

        # Print Node hops
        that.Console.add(" #{hopCount++}  #{current.Network.external_ip_v4} (#{current.Network.external_ip_v4})")


        direction = if (last.lng < 0) then 180 else -180
        lengthGap = Math.abs(last.lng - current.lng)

        if lengthGap > 160
          newEnd =
            lat: current.lat
            lng: direction * -1
          newStart =
            lat: current.lat
            lng: direction


          tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, newEnd)
          tween.start()
          last = newStart


        # Create a animated tween path.
        tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, current)
        tween.start()
        last = current

      # Add null hops for rest of the hopcount durcation
      while hopCount++ < 30
        that.Console.add(" #{hopCount++}  * * *")


      # Finally add path between last node and network
      tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, targetNetwork)
      tween.start()












module.exports = Traceroute