
GothamObject = require './GothamObject.coffee'

class Mission extends GothamObject

  constructor: (model) ->
    super(model)

  getMissionRequirements: ->
    if not @MissionRequirements
      db_missionRequirements = Gotham.LocalDatabase.table("MissionRequirement")
      @MissionRequirements = db_missionRequirements.find({mission: @id})
    return @MissionRequirements




module.exports = Mission

