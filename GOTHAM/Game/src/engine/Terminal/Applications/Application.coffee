optparse = require '../../../dependencies/optparse.js'



class Application
  @Command = undefined




  constructor: (command) ->
    @_commandObject = command
    @Command = command.command
    @Arguments = command.arguments
    @Console = command.controller.console


  ArgumentParser: () ->
    @ArgumentParser = new optparse.OptionParser @switches()
    return @ArgumentParser

  switches: ->
    throw new Error "#{@prototype.constructor.name}.switches() is not overriden. It should Return a array with switches, see https://github.com/jfd/optparse-js/blob/master/examples/browser-test.html"

  execute: ->
    throw new Error "#{@prototype.constructor.name}.execute() is not overriden"


  @GetCommand = ->
    if not @Command
      throw new ReferenceError "Application #{@prototype.constructor.name} is missing a command!"
    return @Command



module.exports = Application