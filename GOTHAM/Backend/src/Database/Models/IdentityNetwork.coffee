
module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'IdentityNetwork', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      identity:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'identity'
        referencesKey: 'id'
      network:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'network'
        referencesKey: 'id'
    },
    {
      tableName: 'identity_network'
      timestamps: false
    }
