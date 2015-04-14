Database = require '../../Database/Database.coffee'
LocalDatabase = require '../../Database/LocalDatabase.coffee'
Traffic = require './Traffic.coffee'
log = require('log4js').getLogger("Pathfinder")

class Pathfinder

  @tryRandom = (start, goal, tryPaths = 100000) ->

    table = LocalDatabase.table("nodes")

    _solution = []
    tries = 0
    minPath = Number.max_value

    rnd = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min

    while (tries < tryPaths)

      queue = []
      currentNode = start
      jumps = 0
      queue.push({id:start.id, start})

      loop
        siblings = currentNode.siblings
        nextNodeId = siblings[rnd(0, siblings.length - 1)].id
        nextNode = table({dataValues: id: nextNodeId}).first()
        queue.push({id:nextNode.id, nextNode})
        currentNode = nextNode
        jumps++
        break if currentNode != goal and jumps > 100

      if currentNode == goal and queue.length < minPath
        _solution = queue;
        minPath = queue.length;
        console.log "found new path"

      tries++
    console.log "Solution:"
    console.log _solution
    return _solution

  @toIdList = (solution) ->

    pathInt = []
    pathInt.push(node.id) for node in solution
    return pathInt

  @toDictionary = (solution) ->

    pairs = {}
    pairs[node.id] = node for node in solution
    return pairs

  @printSolution = (solution) ->

    log.info("Path of nodes:")
    for node in solution
      log.info(node.name)

module.exports = Pathfinder