

###*
# GothamObject - Base Class for Local Model Models
# @class GothamObject
# @constructor
# @param {Sequelize.Model} model
# @required
# @module Backend
# @submodule Backend.LocalDatabase
###
class GothamObject

  ###*
  # List of blacklisted properties when running toJSON()
  # @property {Array} propertyBlacklist
  # @static
  ###
  @propertyBlacklist = ["_model", "$loki", "meta"]

  @create = (attributes, _c) ->
    # The model name
    modelName = @prototype.constructor.name

    # Create with attributes
    Gotham.Database.Model[modelName].create(attributes).then((model) ->

      # Create a new local model entity
      localModel = new Gotham.LocalDatabase.Model[modelName](model)

      # Insert into local database
      Gotham.LocalDatabase.table(modelName).insert localModel

      # Callback
      _c(localModel)
    ).catch((e) ->
      console.log e
      _c(null)
    )


  constructor: (model) ->
    if not model then throw new Error "[GothamObject] Model is not defined"

    ###*
    # The Sequelize Model (Database)
    # @property {Sequelize.Model} _model
    ###
    @_model = model

    for key, val of model.dataValues
      @[key] = val



  ###*
  # Synchronizes the Sequelize Model with the Local Database Model
  # @method modelSync
  ###
  modelSync: ->
    for key, _ of @_model.dataValues
      @_model[key] = @[key]

  ###*
  # Synchronizes the Local Database Model with the Remote Database
  # @method databaseSync
  # @return {Promise}
  ###
  databaseSync: ->
    @modelSync()
    return @_model.update()

  ###*
  # Override toJSON to exclude items from blacklist
  # @Override
  # @method toJSON
  # @return {Object}
  ###
  toJSON: ->
    props = {}
    for key of @
      # Skip Blacklistend properties
      if key in GothamObject.propertyBlacklist
        continue

      if @hasOwnProperty(key)
        props[key] = @[key]

    return props

module.exports = GothamObject