
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
      mac:
        type: DataTypes.STRING
        allowNull: false
    },
    {
      tableName: 'node'
      timestamps: false
      instanceMethods:
        siblings: ->

          if @_siblings
            return @_siblings

          result = []
          for cable in this.Cables
            for node in cable.Nodes
              if node.id != this.id
                result.push node

          @_siblings = result
          return result


    }
