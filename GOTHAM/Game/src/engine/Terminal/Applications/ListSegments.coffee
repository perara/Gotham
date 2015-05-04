Application = require './Application.coffee'


###*
# Application for the "ls" command in Unix.
# @class ListSegments
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class ListSegments extends Application

  @Command = "ls"

  constructor: (command) ->
    super command


  @execute: ->
    command = @command

    output = ""

    files = command.controller.filesystem.ls()

    # Extended LS
    if "-la" in command.arguments
      for filename, child of files

        dirPermission = if child.extension != "dir" then "d" else "-"
        permission = "rwxrwxrwx" #TODO
        owner = command.controller.identity.first_name #TODO
        group = command.controller.identity.first_name #TODO
        size = 4096 # TODO
        createdDate = "Apr 17 20:37" #TODO
        extension = if child.extension != "dir" then ".#{child.extension}" else ""
        filename = filename + extension

        out = "#{dirPermission}#{permission}\t#{owner}\t#{group}\t#{size}\t#{createdDate}\t#{filename}"
        command.controller.console.add out


    else
      for filename, child of files
        ext = if child.extension != "dir" then ".#{child.extension}" else ""
        output += "#{filename}#{ext}    "

      command.controller.console.add output






module.exports = ListSegments