module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'ipprovider',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      from_ip:
        type: DataTypes.STRING
        allowNull: false
      to_ip:
        type: DataTypes.STRING
        allowNull: false
      assign_date:
        type: DataTypes.STRING
        allowNull: false
      country:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'country'
        referencesKey: 'countryCode'
      assign_date:
        type: DataTypes.DATE
        allowNull: true
      owner:
        type: DataTypes.STRING
        allowNull: true
    }
  ,
    {

      tableName: 'country_ip'
      timestamps: false
    }