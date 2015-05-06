module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'UserMission', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      user:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'user'
        referencesKey: 'id'
      mission:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'mission'
        referencesKey: 'id'
      complete:
        type: DataTypes.BOOLEAN
        allowNull: false
    },
    {
      tableName: 'user_mission'
      timestamps: false
    }
