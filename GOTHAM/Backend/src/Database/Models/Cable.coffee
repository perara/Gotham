



module.exports = (sequelize, DataTypes) ->
  return sequelize.define 'Cable',
    {
      id:
        type: DataTypes.INTEGER
        allowNull: false
        primaryKey: true
        autoIncrement: true
      priority:
        type: DataTypes.INTEGER
        allowNull: false
      capacity:
        type: DataTypes
        allowNull: false
      type:
        type: DataTypes.INTEGER
        allowNull: true
        references: 'cable_type'
        referencesKey: 'id'
      distance:
        type: 'DOUBLE'
        allowNull: false
      name:
        type: DataTypes.STRING
        allowNull: false
    },
    {

      tableName: 'cable'
      timestamps: false
      getterMethods:
        load: ->
          load = @_load
          if not load
            load = -1
          return load


      instanceMethods:
        updateLoad: (timeOffset, variation) ->

          if not @CableParts then throw new ReferenceError("CableParts not loaded")

          # Gets the cable parts
          parts = @CableParts
          # Gets the longitude and time offset
          avgLng = parts[0].lng
          # Calculating what time it is on the current latitude (in total minutes)
          minutes = ((avgLng + 180) / 0.25)  + timeOffset

          # Static variable for converting degrees to minutes with 12 hour offset
          deltaMinute = ((2 * Math.PI) / 1440)
          # Calculates the load from a sinus curve peaking at 18:00
          loadValue = Math.sin(deltaMinute * minutes)


          # Uses variation and multiplication to make a fictional amount of bandwidth
          @_load = ((loadValue) + variation) / 10
          return @_load

    }