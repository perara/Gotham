Taffy = require 'taffydb'

class LocalDatabase
  @_tables = {}


  @table: (name) ->
    if not @_tables.name
      @_tables.name = new Taffy.taffy()

    return @_tables.name

module.exports = LocalDatabase