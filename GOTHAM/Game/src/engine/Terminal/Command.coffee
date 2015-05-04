

###*
# Command is a terminal module which parses the input to the terminal. The command registers and identifies which command that should run.
# @class Command
# @module Frontend
# @submodule Frontend.Terminal
# @namespace GothamGame.Terminal
# @constructor
# @param tC {TerminalController} The terminal controller object
# @param input {String} The input string from Terminal input field
###
class Command

  constructor: (tC, input) ->
    @controller = tC
    @input = input
    @commandReference = undefined
    @command = undefined
    @arguments = []

    @parse()

  # Determine weither this is a valid command,
  # @returns {Boolean} is its valid or not
  isCommand: ->
    return !!@commandReference

  parse: ->
    # Split command string
    commandArray = @input.split(" ")

    # Fetch command
    @command = commandArray.splice(0,1)[0]

    # Remainder is arguments
    @arguments.push argument for argument in commandArray

    # Determine if the command exists in any application
    for appName, application of GothamGame.Terminal.Applications

      # Command exist, new instance and reference it.
      if @command == application.GetCommand()
        console.log "Found command: #{@command}"
        @commandReference = new application(@)
        break


  getCommandText: ->
    return @command

  getArgs: ->
    return @arguments

  getInput: ->
    return @input

  execute: ->
    if not @commandReference then throw new Error "RefCommand is not defined!"
    @commandReference.execute()

module.exports = Command