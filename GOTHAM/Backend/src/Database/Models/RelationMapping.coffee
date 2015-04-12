

class RelationMapping


  constructor: (Model) ->
    @Model = Model
    @Mapping_CablePart()
    @Mapping_Cable()
    @Mapping_Host()
    @Mapping_NodeCable()
    @Mapping_Node()



  Mapping_Node: ->
    @Model.Node.belongsToMany @Model.Cable,
      {
        through: 'node_cable'
        foreignKey: 'node'
      }

  Mapping_CablePart: ->
    @Model.CablePart.belongsTo @Model.Cable,
      {
        foreignKey: 'cable'
        allowNull: true
      }
    @Model.Cable.hasMany @Model.CablePart,
      {
        foreignKey: 'cable'
        allowNull: true
      }


  Mapping_CableType: ->


  Mapping_Cable: ->
    @Model.Cable.belongsTo @Model.CableType,
    {
      foreignKey: 'type'
      foreignKeyConstraint:true
    }


  Mapping_Host: ->
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

  Mapping_NodeCable: ->
    @Model.Cable.belongsToMany @Model.Node,
      {
        through: 'node_cable'
        foreignKey: 'cable'
      }




module.exports = RelationMapping
