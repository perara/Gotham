GothamObject = require './GothamObject.coffee'


###*
# Country Model, A country is what you live in.
# @class Country
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Country extends GothamObject

  constructor: (model) ->
    super model

    delete @["country"]


###*
# The identifier for this Country
# @property {Integer} id
###
###*
# The name of the country
# @property {String} name
###
###*
# The countryCode 2-letter
# @property {String} countryCode
###
###*
# The countryCode 3-letter (Extended)
# @property {String} countryCodeExt
###
###*
# The size of the country kvm
# @property {Integer} size
###
###*
# Population of this country
# @property {Integer} population
###
###*
# Continent of the Country
# @property {String} continent
###



module.exports = Country