
class GothamObject

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
    @_model = model

    for key, val of model.dataValues
      @[key] = val

  # Sync this and sequelize object
  modelSync: ->
    for key, _ of @_model.dataValues
      @_model[key] = @[key]

  # Update the database
  # @returns [Promise] Sequelize promize
  databaseSync: ->
    @modelSync()
    return @_model.update()

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