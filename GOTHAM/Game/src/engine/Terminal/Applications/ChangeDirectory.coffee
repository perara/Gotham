Application = require './Application.coffee'

class ChangeDirectory extends Application

  @Command = "cd"


  @execute = (command) ->

    command.controller.filesystem.cd command.arguments











module.exports = ChangeDirectory