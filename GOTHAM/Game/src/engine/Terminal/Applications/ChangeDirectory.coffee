Application = require './Application.coffee'


###*
# Application for the "cd" command.
# @class ChangeDirectory
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class ChangeDirectory extends Application

  @Command = "cd"


  @execute = (command) ->

    command.controller.filesystem.cd command.arguments


module.exports = ChangeDirectory