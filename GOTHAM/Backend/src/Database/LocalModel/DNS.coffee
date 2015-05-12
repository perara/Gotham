GothamObject = require './GothamObject.coffee'


###*
# DNS is a class which keeps records between IP and Hostname
# @class DNS
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class DNS extends GothamObject

  constructor: (model) ->
    super model

  ###*
  # Fetch provider of the DNS record
  # @method getProvider
  # @return {IPProvider} The provider ENtity
  ###
  getProvider: ->
    if not @Provider
      db_provider = Gotham.LocalDatabase.table "IPProvider"
      @Provider = db_provider.findOne(id: @provider)
    return @Provider




###*
# The identifier for this DNS Record
# @property {Integer} id
###
###*
# The ivp4 for this DNS Record
# @property {String} ivp4
###
###*
# The ipv6 for this DNS Record
# @property {String} ipv6
###
###*
# The address for this DNS Record
# @property {String} address
###
###*
# The provider for this DNS Record
# @property {Integer} provider
###





module.exports = DNS