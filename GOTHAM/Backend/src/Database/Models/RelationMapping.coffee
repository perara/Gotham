

class RelationMapping


  constructor: (Model) ->
    @Model = Model
    @Mapping_CablePart()
    @Mapping_Cable()

    @Mapping_NodeCable()
    @Mapping_Node()
    @Mapping_Host()
    @Mapping_Identity()
    @Mapping_User()
    @Mapping_Network()
    @Mapping_Mission()



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

  Mapping_Mission: ->

    @Model.Mission.hasMany @Model.MissionRequirement,
      {
        foreignKey: 'mission'
        allowNull: false
      }



  Mapping_CableType: ->

  Mapping_User: ->
    @Model.User.hasMany @Model.Identity,
      {
        foreignKey: 'fk_user'
        foreignKeyConstraint:true
      }


  Mapping_Identity: ->
    @Model.Identity.belongsTo @Model.User,
      {
        foreignKey: 'fk_user'
        allowNull: true
      }

    @Model.Identity.hasMany @Model.Network,
      {
        foreignKey: 'identity'
        allowNull: false
      }

  Mapping_Network: ->
    @Model.Network.belongsTo @Model.Node,
      {
        foreignKey: 'node'
        allowNull: false
      }

    @Model.Network.hasMany @Model.Host,
      {
        foreignKey: 'network'
        allowNull: false
      }








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

    """@Model.Host.belongsTo @Model.Identity,
      {
        foreignKey: 'identity'
        foreignKeyConstraint: true
      }

    @Model.Host.belongsTo @Model.Network,
      {
        foreignKey: 'network'
        foreignKeyConstraint:true
      }"""

  Mapping_NodeCable: ->
    @Model.Cable.belongsToMany @Model.Node,
      {
        through: 'node_cable'
        foreignKey: 'cable'
      }

    @Model.Node.belongsToMany @Model.Cable,
      {
        through: 'node_cable'
        foreignKey: 'node'
      }





module.exports = RelationMapping
