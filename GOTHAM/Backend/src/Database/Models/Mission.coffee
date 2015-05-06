module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Mission',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      title:
        type: DataTypes.STRING
        allowNull: false
      description:
        type: DataTypes.STRING
        allowNull: false
      description_ext:
        type: DataTypes.STRING
        allowNull: false
      required_xp:
        type: DataTypes.INTEGER
        allowNull: false
      experience_gain:
        type: DataTypes.INTEGER
        allowNull: false

    },
    {

      tableName: 'mission'
      timestamps: false
    }