Application = require './Application.coffee'


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
    GothamGame.network.Socket.emit 'Traceroute', @Packet

    # Traceroute Callback
    GothamGame.network.Socket.on 'Traceroute', (path, output) ->
      @removeListener('Traceroute')
      db_node = Gotham.Database.table("node")

      that.Console.addArray output

      # Clear old paths
      GothamGame.renderer.getScene("World").getObject("WorldMap").View.clearAnimatePath()

      last = that._commandObject.controller.network # Basicly the host location
      for nodeID in path
        current = db_node({id: nodeID}).first()

        tween = GothamGame.renderer.getScene("World").getObject("WorldMap").View.animatePath(last, current)
        tween.start()
        last = current


        #traceroute 3.0.0.8












module.exports = Traceroute