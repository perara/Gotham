

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Network', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      submask:
        type: DataTypes.STRING
        allowNull: false
      internal_ip_v4:
        type: DataTypes.STRING
        allowNull: false
      external_ip_v4:
        type: DataTypes.STRING
        allowNull: false
      isLocal:
        type: DataTypes.BOOLEAN
        allowNull: false
      lat:
        type: DataTypes.DECIMAL
        allowNull: false
      lng:
        type: DataTypes.DECIMAL
        allowNull: false
      mac:
        type: DataTypes.STRING
        allowNull: false
      node:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'node'
        referencesKey: 'id'
    },
    {
      tableName: 'network'
      timestamps: false
    }
