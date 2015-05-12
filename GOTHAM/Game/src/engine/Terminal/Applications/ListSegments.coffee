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


  execute: ->

    output = ""

    files = @Controller.filesystem.ls()

    # Extended LS
    if "-la" in @Arguments

      # For each of the files
      for filename, child of files

        # Create output structure
        # -rwxrwxrwx	Sherrifah	Sherrifah	4096	Apr 17 20:37	dir1
        dirPermission = if child.extension != "dir" then "d" else "-"
        permission = "rwxrwxrwx" #TODO
        owner = @Controller.identity.first_name #TODO
        group = @Controller.identity.first_name #TODO
        size = 4096 # TODO
        createdDate = "Apr 17 20:37" #TODO
        extension = if child.extension != "dir" then ".#{child.extension}" else ""
        filename = filename + extension

        out = "#{dirPermission}#{permission}\t#{owner}\t#{group}\t#{size}\t#{createdDate}\t#{filename}"
        @Console.add out


    else
      for filename, child of files
        ext = if child.extension != "dir" then ".#{child.extension}" else ""
        output += "#{filename}#{ext}    "

      @Console.add output






module.exports = ListSegments