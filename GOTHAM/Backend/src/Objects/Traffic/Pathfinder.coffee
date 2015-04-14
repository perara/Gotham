Database = require '../../Database/Database.coffee'
Traffic = require './Traffic.coffee'

class Pathfinder

  @tryRandom: (start, goal, tryPaths = 100000) ->

    _solution = []
    tries = 0
    minPath = Number.max_value
    rnd: (min, max) -> Math.floor(Math.random() * (max - min + 1)) + min

    while (tries < tryPaths)

      queue = []
      currentNode = start
      jumps = 0
      queue.push({id:start.id, start})

      loop
        nextNode = currentNode.siblings[rnd(0, currentNode.siblings.length - 1)]        # var nextNode = currentNode.GetSiblings()[rnd.Next(0, currentNode.GetSiblings().Count - 1)];
        queue.push({id:nextNode.id, nextNode})
        currentNode = nextNode
        jumps++
        break if currentNode != goal and jumps < 100

      if currentNode == goal and queue.length < minPath
        _solution = queue;
        minPath = queue.length;

      tries++

    return _solution

  @toIdList: (solution) ->

    pathInt = []
    pathInt.push(node.id) for node in solution
    return pathInt

  @toDictionary: (solution) ->

    pairs = {}
    pairs[node.id] = node for node in solution
    return pairs

  @printSolution: (solution) ->

    log.info("Path of nodes:")

    for node in solution
      log.info(node.name)

module.exports = Pathfinder