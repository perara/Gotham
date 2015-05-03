
module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'NodeCable', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      node:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'node'
        referencesKey: 'node'
      cable:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'cable'
        referencesKey: 'cable'

    },
    {
      tableName: 'node_cable'
      timestamps: false
    }
