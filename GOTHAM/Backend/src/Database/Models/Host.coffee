

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
        allowNull: false
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
      network:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'network'
        referencesKey: 'id'

    },
    {
      tableName: 'host'
      timestamps: false
    }
