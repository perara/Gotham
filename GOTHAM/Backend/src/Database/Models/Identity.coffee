
module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Identity', {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      fk_user:
        type: DataTypes.INTEGER
        allowNull: false
        references: 'user'
        referencesKey: 'id'
      first_name:
        type: DataTypes.STRING
        allowNull: false
      last_name:
        type: DataTypes.STRING
        allowNull: false
      birthday:
        type: DataTypes.STRING
        allowNull: false
      address:
        type: DataTypes.STRING
        allowNull: false
      city:
        type: DataTypes.STRING
        allowNull: false
      country:
        type: DataTypes.STRING
        allowNull: false
      email:
        type: DataTypes.STRING
        allowNull: false
      username:
        type: DataTypes.STRING
        allowNull: false
      password:
        type: DataTypes.STRING
        allowNull: false
      occupation:
        type: DataTypes.STRING
        allowNull: false
      company:
        type: DataTypes.STRING
        allowNull: false
      lat:
        type: DataTypes.DECIMAL
        allowNull: false
      lng:
        type: DataTypes.DECIMAL
        allowNull: false
      active:
        type: DataTypes.BOOLEAN
        allowNull: false
    },
    {
      tableName: 'identity'
      timestamps: false
    }
