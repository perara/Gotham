



class Application

  @Command = undefined


  @execute = ->
    throw new Error "#{@prototype.constructor.name}.execute() is not overriden"

  @GetCommand = ->
    if not @Command
      throw new ReferenceError "Application #{@prototype.constructor.name} is missing a command!"


    return @Command



module.exports = Application