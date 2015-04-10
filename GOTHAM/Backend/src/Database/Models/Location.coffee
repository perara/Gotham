



module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Location',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      countryCode:
        type: DataTypes.STRING
        allowNull: false
        references: 'country'
        referencesKey: 'id'
      name:
        type: DataTypes.STRING
        allowNull: false
      lat:
        type: 'DOUBLE'
        allowNull: false
      lng:
        type: 'DOUBLE'
        allowNull: false
    }
  ,
    {

      tableName: 'location'
      timestamps: false
    }