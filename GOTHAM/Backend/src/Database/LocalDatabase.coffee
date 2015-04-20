Loki = require 'lokijs'

class LocalDatabase

  that = @
  @db = null
  @_tables = {}
  @nodesLoaded = false
  @cablesLoaded = false

  @table: (name) ->
    @db = if not @db then new Loki 'loki.json'

    if not @_tables[name]
      @_tables[name] = @db.addCollection(name, { indices: ['id'] })

    return @_tables[name]

  @database: ->
    return @db

  @updateNodes: (database) ->

    database.Model.Node.all({ include: [{ all: true, nested: true }]}).then (nodes)->

      nodeList = LocalDatabase.table("nodes")
      cableList = LocalDatabase.table("cables")

      for node in nodes
        nodeList.insert {id: node.id, node: node}

        for cable in node.Cables
          cableList.insert {id: cable.id, cable: cable}

      that.nodesLoaded = true
  """
  @updateCables: (database) ->

    database.Model.Cable.all(
      include: [
        {
          model: database.Model.CablePart
          include: [database.Model.Cable]
        }
      ]
    ).then (cables)->

      cableList = LocalDatabase.table("cables")

      for cable in cables
        cableList.insert {id: cable.id, cable: cable}

      that.cablesLoaded = true
  """
module.exports = LocalDatabase
