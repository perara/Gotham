GothamObject = require './GothamObject.coffee'

###*
# CablePart class, Contains all the cable parts for a single cable
# @class CablePart
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class CablePart extends GothamObject

  constructor: (model) ->
    super(model)

###*
# The identifier for the CablePart
# @property {Integer} id
###
###*
# The cable associated (ID)  to these cable types
# @property {Integer} cable
###
###*
# The Cable segment number, 0 is the first segment. These segment are listied sorted ( 0, 1 ,2 ,3 ,0 )
# @property {Integer} number
###
###*
# Latitude component of the location
# @property {Double} lat
###
###*
# Longitude component of the location
# @property {Double} lng
###

module.exports = CablePart