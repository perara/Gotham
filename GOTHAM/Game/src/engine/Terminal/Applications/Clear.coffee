Application = require './Application.coffee'



###*
# Application for the clear command in Unix
# @class Clear
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class Clear extends Application

  @Command = "clear"


module.exports = Clear