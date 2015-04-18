
# Command class
class Command

  constructor: (tC, input) ->
    @controller = tC
    @input = input
    @commandReference = undefined
    @command = undefined
    @arguments = []

    @Parse()

  # Determine weither this is a valid command,
  # @returns {Boolean} is its valid or not
  isCommand: ->
    return !!@commandReference

  Parse: ->
    # Split command string
    commandArray = @input.split(" ")

    # Fetch command
    @command = commandArray.splice(0,1)[0]

    # Remainder is arguments
    @arguments.push argument for argument in commandArray

    # Determine if the command exists in any application
    for appName, application of GothamGame.Terminal.Applications

      # Command exist, reference it.

      if @command == application.GetCommand()
        console.log "Found command: #{@command}"
        @commandReference = application
        break


  getCommandText: ->
    return @command

  getArgs: ->
    return @arguments

  getInput: ->
    return @input

  execute: ->
    if not @commandReference then throw new Error "RefCommand is not defined!"
    @commandReference.execute(@)

module.exports = Command