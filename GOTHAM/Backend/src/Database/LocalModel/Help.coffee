GothamObject = require './GothamObject.coffee'
###*
# Help, A entity which contains all help texts
# @class Help
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Help extends GothamObject

  constructor: (model) ->
    super(model)

  getChildren: ->
    if not @Children
      db_help = Gotham.LocalDatabase.table "Help"
      @Children = db_help.find(parent: @id)
    return @Children


###*
# The id of the identity
# @property {Integer} id
###
###*
# The title of the help item
# @property {String} title
###
###*
# The text of the help item
# @property {String} text
###
###*
# The parent of the help item
# @property {Integer} parent
###




module.exports = Help