Application = require './Application.coffee'

###*
# Application for Ping which simulates Unix based ping
# @class Ping
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class Ping  extends Application
  @Command = "ping"

  constructor: (command) ->
    super command

    @Packet =
      sourceHost: null
      target: null
      inverval: 1
      count: 5
      packetsize: 56
      quiet: false
      deadline: false
      max_ttl: 56




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

    # No Arguments, Show HELP
    parser.on(->that.Console.addArray @toString().split("\n"))

    # Fetch the IP address, which should be located at the beginning or end of the command
    # Example: ping 192.168.10.101 | ping -c 2 192.168.10.101
    fetchIPAddress = (ipHost) ->
      if GothamGame.Tools.HostUtils.validIPHost(ipHost)
        that.Packet.target = ipHost
      else
        that.Console.add "#{that.Command}: unknown host: #{ipHost}"

    # Beginning and end of argument list
    [0, @Arguments.length].forEach (idx) ->
      parser.on idx, fetchIPAddress

    # Run argument parsing
    parser.parse(@Arguments)

    # Host ID - Which should be resolved to resolve to Host IP
    @Packet.sourceHost = @_commandObject.controller.host.id



    # Emit to server if target is set
    if @Packet.target
      # Send emit to Frontend Mission Engine, Callback are received on Completion
      GothamGame.MissionEngine.emit "Ping", @Packet.target, (req) ->
        GothamGame.Announce.message "#{req._mission._title}\n#{req._requirement} --> #{req._current}/#{req._expected}", "MISSION", 50

      # Emit the ping rwquest back to the server
      GothamGame.Network.Socket.emit 'Ping', @Packet
      GothamGame.Network.Socket.on 'Ping_Host_Not_found', ->
        @removeListener('Ping_Host_Not_found')
        that.Console.add "ping: unknown host #{that.Packet.target}"

      GothamGame.Network.Socket.on 'Ping', (session) ->
        @removeListener('Ping_Host_Not_found')
        @removeListener('Ping')

        that.Console.add("PING #{session.target} (#{session.target}) #{session.packetsize}(#{session.packetsize+session.HEADER_SIZE}) bytes of data.")

        i = 0
        startTime = Date.now()
        duration = null
        min_rtt = 10000000
        max_rtt = -1000000
        avg_rtt = 0

        onDone = ->
          that.Console.add "--- #{session.target} ping statistics ---"
          that.Console.add "#{i} packets transmitted, #{i} received, 0% packet loss, time #{duration}ms"
          that.Console.add "rtt min/avg/max = #{min_rtt.toFixed(3)}/#{max_rtt.toFixed(3)}/#{avg_rtt.toFixed(3)} ms"

        for ping in session.pings
          setTimeout (()->
            randomRTT = Math.floor(Math.random() * (ping.rtt + 10)) + Math.max(ping.rtt - 10, 0)
            avg_rtt += randomRTT
            if randomRTT < min_rtt
              min_rtt = randomRTT
            if randomRTT > max_rtt
              max_rtt = randomRTT

            that.Console.add "#{session.packetsize + 8} bytes from (#{session.target}): icmp_seq=#{i++} ttl=#{that.Packet.max_ttl} time=#{randomRTT.toFixed(3)} ms"

            if i >= session.pings.length
              duration = Date.now() - startTime
              avg_rtt = avg_rtt / i
              onDone()

          ), ping.time






module.exports = Ping