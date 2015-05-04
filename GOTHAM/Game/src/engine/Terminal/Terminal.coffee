'use strict'


###*
# Terminal Class is a collection of modules. These modules in total represents a terminal which can be used by the User
# @class Terminal
# @module Frontend
# @submodule Frontend.Terminal
# @namespace GothamGame.Terminal
###
class Terminal

  constructor: ->
  @Command = require './Command.coffee'
  @Filesystem = require './Filesystem.coffee'
  @Console = require './Console.coffee'

  @Applications =
    'ChangeDirectory': require './Applications/ChangeDirectory.coffee'
    'Move': require './Applications/Move.coffee'
    'Copy':require './Applications/Copy.coffee'
    'Clear':require './Applications/Clear.coffee'
    'Ping':require './Applications/Ping.coffee'
    'Slowloris':require './Applications/Slowloris.coffee'
    'ListSegments': require './Applications/ListSegments.coffee'
    'Traceroute': require './Applications/Traceroute.coffee'

module.exports = Terminal
