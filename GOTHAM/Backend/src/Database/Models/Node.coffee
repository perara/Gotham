

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Node', {
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
        references: 'country'
        referencesKey: 'countryCode'
      tier:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'tier'
        referencesKey: 'id'
      priority:
        type: DataTypes.INTEGER
        allowNull: true
      bandwidth:
        type: "DOUBLE"
        allowNull: false
      lat:
        type: DataTypes.DECIMAL
        allowNull: false
      lng:
        type: DataTypes.DECIMAL
        allowNull: false
    },
    {
      tableName: 'node'
      timestamps: false
    }
