

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Help', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      title:
        type: DataTypes.STRING
        allowNull: false
      text:
        type: DataTypes.TEXT
        allowNull: false
      parent:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'help'
        referencesKey: 'id'
    },
    {
      tableName: 'help'
      timestamps: false
    }
