Datastore = require 'nedb'

class LocalDatabase
  @_tables = {}


  @table: (name) ->
    if not @_tables.name
      @_tables.name = new Datastore()

    return @_tables.name

module.exports = LocalDatabase