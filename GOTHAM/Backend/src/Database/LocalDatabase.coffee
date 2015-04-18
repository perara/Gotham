Loki = require 'lokijs'

class LocalDatabase

  @db = null
  @_tables = {}

  @table: (name) ->
    @db = if not @db then new Loki 'loki.json'

    if not @_tables[name]
      @_tables[name] = @db.addCollection(name, { indices: ['id'] })

    return @_tables[name]

  @database: ->
    return @db

module.exports = LocalDatabase
