



module.exports = (sequelize, DataTypes) ->
  Cable = sequelize.define 'Cable',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      priority:
        type: DataTypes.INTEGER
        allowNull: false
      capacity:
        type: DataTypes
        allowNull: false
      type:
        type: DataTypes.INTEGER
        allowNull: true
        references: 'cable_type'
        referencesKey: 'id'
      distance:
        type: 'DOUBLE'
        allowNull: false
      name:
        type: DataTypes.STRING
        allowNull: false
    }
    ,
    {

      tableName: 'cable'
      timestamps: false
    }




  return Cable
