

module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Filesystem', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      data:
        type: DataTypes.TEXT
        allowNull: false
    },
    {
      tableName: 'filesystem'
      timestamps: false
    }
