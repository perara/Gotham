
module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Person', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      givenname:
        type: DataTypes.STRING
        allowNull: false
    },
    {
      tableName: 'person'
      timestamps: false
    }
