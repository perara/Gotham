
class GothamObject

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
    tmp = @_model
    @_model = null
    json = JSON.parse(@)
    @_model = tmp
    return json






module.exports = GothamObject