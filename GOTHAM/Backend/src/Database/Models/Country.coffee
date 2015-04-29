module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Country',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      name:
        type: DataTypes.STRING
        allowNull: false
      countryCode:
        type: DataTypes.STRING
        allowNull: false
      countryCodeExt:
        type: DataTypes.STRING
        allowNull: false
      size:
        type: 'DOUBLE'
        allowNull: false
      population:
        type: DataTypes.INTEGER
        allowNull: false
      continent:
        type: DataTypes.STRING
        allowNull: false
    }
  ,
    {
      tableName: 'country'
      timestamps: false
    }