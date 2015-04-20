Application = require './Application.coffee'

class Ping  extends Application

  @Command = "ping"
  @Arguments =
    '-c':
      description: "count"
      function: ->
    '-i':
      description: "interval"
      function: ->
    '-m':
      description: "mark"
      function: ->
    '-M':
      description: "pmtudisc_option"
      function: ->
    '-l':
      description: "preload"
      function: ->
    '-p':
      description: "pattern"
      function: ->
    '-Q':
      description: "tos"
      function: ->
    '-s':
      description: "packetsize"
      function: ->
    '-S':
      description: "sndbuf"
      function: ->
    '-t':
      description: "ttl"
      function: ->
    '-T':
      description: "timestamp_option"
      function: ->
    '-w':
      description: "deadline"
      function: ->
    '-W':
      description: "timeout"
      function: ->
    '-V':
      description: "version"
      function: (command) ->
        command.controller.console.add "#{Command} utility, iputils-GOTHAM-0.00141"



  @execute: (command) ->
    args = command.arguments

    # No arguments
    if args.length < 1
      @help(command)
      return

    # Set address variable and validate the adress.
    # If its not validated return error and stop execution.
    address = args.last()
    if not GothamGame.Tools.HostUtils.validIPHost(address)
      command.controller.console.add "#{@Command}: unknown host: #{address}"
      return

    GothamGame.network.Socket.emit 'Ping', {
      address: address
    }
    GothamGame.network.Socket.on 'Ping', (items) ->

      i = 0
      id = setInterval(->
        if items.length == 0
          clearInterval(id)
          return

        item = items.shift()
        command.controller.console.add item


      ,1000)




  @help: (command) ->
    output = "Usage: #{@Command} "
    for arg, option of @Arguments
      output += "[#{arg} #{option.description}] "
    output += "destination"

    command.controller.console.add(output)






module.exports = Ping