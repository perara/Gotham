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

module.exports = Move