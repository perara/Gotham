GothamObject = require './GothamObject.coffee'

class Host extends GothamObject

  constructor: (model) ->
    super(model)


  getFilesystem: ->
    if not @Filesystem
      db_filesystem = Gotham.LocalDatabase.table("Filesystem")
      @Filesystem = db_filesystem.findOne({id: @filesystem})
    return @Filesystem

  getNetwork: ->
    if not @Network
      db_network = Gotham.LocalDatabase.table("Network")
      @Network = db_network.findOne({id: @network})
    return @Network




module.exports = Host