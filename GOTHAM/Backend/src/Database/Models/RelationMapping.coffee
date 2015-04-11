

class RelationMapping


  constructor: (Model) ->
    @Model = Model
    @CableMapping()
    @HostMapping()


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

  HostMapping: ->
    @Model.Host.belongsTo @Model.Filesystem,
      {
        foreignKey: 'filesystem'
        foreignKeyConstraint:true
      }

    @Model.Host.belongsTo @Model.Person,
      {
        foreignKey: 'owner'
        foreignKeyConstraint:true
      }



  NodeMapping: ->


module.exports = RelationMapping
