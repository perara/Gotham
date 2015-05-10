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


  execute: ->

    @Controller.filesystem.cd @Arguments


module.exports = ChangeDirectory