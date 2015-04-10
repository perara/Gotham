module.exports = (sequelize, DataTypes) ->
    return sequelize.define 'User',
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      username:
        type: DataTypes.STRING
        allowNull: false
      password:
        type: DataTypes.STRING
        allowNull: false
      email:
        type: DataTypes.STRING
        allowNull: true
      money:
        type: DataTypes.INTEGER
        allowNull: false
      experience:
        type: DataTypes.INTEGER
        allowNull: false
      ,
        tableName: 'User'
        timestamps: false
