

class RelationMapping


  constructor: (Model) ->
    @Model = Model
    @CableMapping()


  CableMapping: ->
    @Model.Cable.belongsTo @Model.CableType,
    {
      foreignKey: 'type'
      foreignKeyConstraint:true
    }
    @Model.CableType.hasOne @Model.Cable,
    {
      foreignKey: 'type'
    }

  NodeMapping: ->


module.exports = RelationMapping
