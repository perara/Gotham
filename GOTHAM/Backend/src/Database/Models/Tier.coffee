module.exports = (sequelize, DataTypes) ->
    return sequelize.define 'Tier', {
        id:
          type: DataTypes.INTEGER
          allowNull: false
          primaryKey: true
          autoIncrement: true
        name:
          type: DataTypes.STRING
          allowNull: false
      },
      {
        tableName: 'tier'
        timestamps: false
      }




