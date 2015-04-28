Application = require './Application.coffee'

class Ping  extends Application
  @Command = "ping"

  constructor: (command) ->
    super command

    @Packet =
      target: null


  switches: ->
    that = @
    return [

      # Help
      ['-h', '--help', 'Show Help', ->
        that.Console.addArray @toString().split("\n")
        that.Packet = {}
      ]

      # Count
      ['-c', '--count NUMBER', 'Stop after sending count ECHO_REQUEST packets', (key, val) ->
        that.Packet.count = val
      ]

      # Interval
      ['-i', '--interval DOUBLE', 'Ping Interval', (key, val)->
        that.Packet.interval = val
      ]

      # Packet Size
      ['-s', '--packetsize NUMBER', 'Packetsize', (key, val)->
        that.Packet.packetsize = val
      ]

      # Quiet Mode
      ['-q', '--quiet', 'Quiet output.', (key, val)->
        that.Packet.quiet = true
      ]

      # Deadline
      ['-w', '--deadline NUMBER', 'Specify a timeout, in seconds, before ping exits', (key, val)->
        that.Packet.deadline = val
      ]

      # Version
      ['-V', '--version', 'Show version number', (key, val)->
        that.Console.add "ping utility, iputils-GOTHAM2010002"
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

    # Parse arguments
    parser.parse(@Arguments)


    # Emit to server if target is set
    if @Packet.target

      # Send emit to Frontend Mission Engine, Callback are received on Completion
      GothamGame.MissionEngine.emit "Ping", @Packet.target, (req) ->
        GothamGame.Announce.message "#{req._mission._title}\n#{req._requirement} --> #{req._current}/#{req._expected}", "MISSION", 50

      # Emit Ping Missions time requirement
      target = @Packet.target
      intervalID = setInterval (() ->
        GothamGame.MissionEngine.emit "Time", target, (req) ->
          console.log req
      ),1000


      # Send Emit to Backend server for an generated response
      GothamGame.Network.Socket.emit 'Ping', @Packet

      # Ping Init (Start of ping)
      GothamGame.Network.Socket.on 'Ping_Init', (output) ->
        that.Console.add output

      # Actual Ping Callback
      GothamGame.Network.Socket.on 'Ping', (output) ->
        that.Console.add output

      # Ping Summary
      GothamGame.Network.Socket.on 'Ping_Summary', (output) ->

        # Stop the Mission Time interval counter
        clearInterval intervalID

        # Ping Event Done, Remove listeners
        @removeListener('Ping')
        @removeListener('Ping_Init')
        @removeListener('Ping_Summary')

        that.Console.addArray output



module.exports = Ping