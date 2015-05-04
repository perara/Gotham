Application = require './Application.coffee'


###*
# Application for the "cp" command in Unix
# @class Copy
# @module Frontend
# @submodule Frontend.Terminal.Application
# @extends Application
# @namespace GothamGame.Terminal.Application
###
class Copy  extends Application

  @Command = "cp"


module.exports = Copy