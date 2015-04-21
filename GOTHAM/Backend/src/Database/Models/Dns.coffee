module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'dns',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      ipv4:
        type: DataTypes.STRING
        allowNull: false
      ipv6:
        type: DataTypes.STRING
        allowNull: true
      address:
        type: DataTypes.STRING
        allowNull: true
      provider:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'provider'
        referencesKey: 'id'
    }
  ,
    {

      tableName: 'dns'
      timestamps: false
    }