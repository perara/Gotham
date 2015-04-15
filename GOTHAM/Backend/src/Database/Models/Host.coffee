

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Host', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      machine_name:
        type: DataTypes.STRING
        allowNull: false
      online:
        type: DataTypes.BOOLEAN
        allowNull: true
        references: 'filesystem'
        referencesKey: 'id'
      person:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'person'
        referencesKey: 'id'
      ip:
        type: DataTypes.STRING
        allowNull: false
      mac:
        type: DataTypes.STRING
        allowNull: false
      filesystem:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'filesystem'
        referencesKey: 'id'
      node:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'node'
        referencesKey: 'id'

    },
    {
      tableName: 'host'
      timestamps: false
    }
