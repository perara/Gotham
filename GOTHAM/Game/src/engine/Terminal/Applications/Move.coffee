Application = require './Application.coffee'

###*
# Application for the mv comamnd in Unix
# @class Move
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class Move extends Application

  @Command = "mv"

  constructor: (command) ->
    super command


  locate: (splitArgument) ->

    # Move to root
    if splitArgument[0] == ""
      target = @Controller.filesystem._root
    # Start at current node by default
    else
      target = @Controller.filesystem._fs

    # Execution argument chain
    for action in splitArgument

      # Do nothing, (Set to current directory)
      if action == "."
        target = @Controller.filesystem._fs

      # Move up in the tree
      else if action == ".."
        if target.parent
          if target.parent.extension == "dir"
            target = target.parent
          else
            console.log "Could NOT FIND... (not dir)"

      # Move into child with name
      else
        if target.children[action]
          target = target.children[action]

    return target



  execute : ->

    console.log @Arguments
    console.log @

    # Split the argument chain
    splitArgument = @Arguments[0].split("/")


    path = @locate(splitArgument)
    console.log path
    console.log splitArgument


















module.exports = Move