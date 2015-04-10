

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'CableType',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      name:
        type: DataTypes.STRING
        allowNull: false
    }
      ,
    {
      tableName: 'cable_type'
      timestamps: false
    }