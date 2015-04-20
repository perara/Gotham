'use strict'

class Terminal

  constructor: ->

    console.log ":D"

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

module.exports = Terminal
