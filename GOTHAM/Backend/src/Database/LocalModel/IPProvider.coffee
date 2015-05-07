GothamObject = require './GothamObject.coffee'


###*
# Provider model is the IP block definition
# @class IPProvider
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class IPProvider extends GothamObject

  constructor: (model) ->
    super model






###*
# The identifier for this Provider
# @property {Integer} id
###
###*
# The from_ip for this Provider
# @property {String} from_ip
###
###*
# The to_ip for this Provider
# @property {String} to_ip
###
###*
# The assign_date for this Provider
# @property {Date} assign_date
###
###*
# The country for this Provider
# @property {String} country
###
###*
# The owner for this Provider
# @property {String} owner
###





module.exports = IPProvider