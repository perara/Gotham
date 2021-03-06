module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'UserMissionRequirement', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      user_mission:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'user_mission'
        referencesKey: 'id'
      mission_requirement:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'mission_requirement'
        referencesKey: 'id'
      current:
        type: DataTypes.STRING
        allowNull: false
      expected:
        type: DataTypes.STRING
        allowNull: false
      emit_input:
        type: DataTypes.STRING
        allowNull: false
      emit_value:
        type: DataTypes.STRING
        allowNull: false
    },
    {
      tableName: 'user_mission_requirement'
      timestamps: false
    }
