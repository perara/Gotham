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


  switches: ->
    that = @
    return [

      # Help
      ['-h', '--help', 'Show Help', ->
        that.Console.addArray @toString().split("\n")
        that.Packet = {}
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
    GothamGame.Network.Socket.emit 'Traceroute', @Packet

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

      for nodeID in path

        # Find the node in the database
        current = db_node.findOne({id: nodeID})


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

      # Finally add path between last node and network
      tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, targetNetwork)
      tween.start()












module.exports = Traceroute