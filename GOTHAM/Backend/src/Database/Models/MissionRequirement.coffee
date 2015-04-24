module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'MissionRequirement',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      mission:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'mission'
        referencesKey: 'id'
      requirement:
        type: DataTypes.STRING
        allowNull: false
      default:
        type: DataTypes.STRING
        allowNull: false
      expected:
        type: DataTypes.STRING
        allowNull: false
      emit:
        type: DataTypes.STRING
        allowNull: false
      emit_value:
        type: DataTypes.STRING
        allowNull: false
      emit_behaviour:
        type: DataTypes.STRING
        allowNull: false

    },
    {
      tableName: 'mission_requirement'
      timestamps: false
    }