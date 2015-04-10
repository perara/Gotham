

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'CablePart', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      cable:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'cable'
        referencesKey: 'id'
      number:
        type: DataTypes.INTEGER
        allowNull: true
      lat:
        type: "DOUBLE"
        allowNull: false
      lng:
        type: "DOUBLE"
        allowNull: false
    },
    {
      tableName: 'cable_part'
      timestamps: false
    }
