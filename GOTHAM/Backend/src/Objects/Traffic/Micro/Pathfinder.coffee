Micro = require './Micro.coffee'
GeoTool = require '../../../Tools/GeoTool.coffee'
performance = require 'performance-now'
log = require('log4js').getLogger("Pathfinder")


class Pathfinder


  table = Gotham.LocalDatabase.table("nodes")

  ###############################################################################################
  ##### Tries random paths and returns the shortest that reached the goal
  ###############################################################################################
  @tryRandom = (start, goal, tryPaths = 100000) ->

    sum = 0
    minPath = Number.MAX_VALUE

    path = []
    tries = 0

    rnd = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min


    startTime = performance()

    while (tries < tryPaths)

      queue = []
      currentNode = start
      jumps = 0
      queue.push(start)

      loop

        siblings = currentNode.siblings()

        nextNodeId = siblings[rnd(0, siblings.length - 1)].id

        deltaTime = new Date().getTime()
        nextNode = table.findOne({id: nextNodeId}).node
        sum += (new Date().getTime() - deltaTime)
        queue.push(nextNode)
        currentNode = nextNode
        jumps++


        break if currentNode.id == goal.id or jumps > 50

      if currentNode == goal and queue.length < minPath
        path = queue;
        minPath = queue.length;
        console.log "found new path"

      tries++

    console.log ("Pathfinding: #{(performance() - startTime)} ms --- Deltatime: " + sum)

    return path


  ###############################################################################################
  ##### Uses geometric locations of siblings to generate a path
  ###############################################################################################
  @aStar: (start, goal) ->

    maxPathLength = 100
    path = []
    blacklist = []
    path.push(start)
    blacklist.push(start.id)

    reverse = (node) ->
      blacklist.push(node.id)
      path.pop()
      log.info "Foul Node #{node.id}"

    addNode = (node) ->
      path.push(node)
      blacklist.push(node.id)
      log.info "Fine Node #{node.id}"

    start = performance()
    loop

      currentId = path[path.length - 1].id
      current = table.findOne({id: currentId}).node
      nextNode = GeoTool.getClosest(goal, current.siblings(), blacklist)
      wrongWay = 0

      log.info "Current node: #{current.id}"
      log.info "Nodes in path: #{path.length}"

      if not nextNode
        reverse(current)
        continue
      if GeoTool.getDistance(current, goal) < GeoTool.getDistance(nextNode, goal)
        wrongWay++
      if wrongWay > 1
        reverse(current)
        continue
      if nextNode not in path
        addNode(nextNode)
      else
        log.info "No node added, why?"

      log.info "Node #{path[path.length - 1].id} vs #{goal.id}\n"

      break if path[path.length - 1].id == goal.id or path.length > maxPathLength

    log.info "Path found in: #{performance() - start} ms"
    return path


  ###############################################################################################
  ##### Improvement of aStar, supports reversing and removal of obsolete nodes
  ###############################################################################################
  @bStar: (start, goal, startBacktrack = 3, escalations = 5) ->

    # Declarations
    path = []
    blacklist = []
    allSiblingIds = {}
    path.push(start)
    blacklist.push(start.id)
    wrongWay = 0
    best = null
    maxBacktrack = startBacktrack

    ###############################################################################################
    ##### Returns sibling closest to goal (gets siblings list from input node)
    ###############################################################################################
    getBestSibling = (current) ->
      bestSibling = GeoTool.getClosest(goal, current.siblings(), blacklist)

      for sibling in current.siblings()

        if bestSibling.id == sibling.id then continue
        allSiblingIds[sibling.id] = path.length

      return GeoTool.getClosest(goal, current.siblings(), blacklist)

    ###############################################################################################
    ##### Gets the distance from input note to goal
    ###############################################################################################
    getGoalDist = (node) ->
      return GeoTool.getDistance(node, goal)

    ###############################################################################################
    ##### Reverses, removing foul nodes and adding them to blacklist
    ###############################################################################################
    reverse = (reverses = 1) ->
      for [0...reverses]
        pathLength = path.length
        removed = path.pop()
        for key, value of allSiblingIds
          if value == pathLength
            delete allSiblingIds[key]
        #log.info "Foul Node #{removed.id}"

    ###############################################################################################
    ##### Adds i fine node
    ###############################################################################################
    addNode = (node) ->
      path.push(node)
      blacklist.push(node.id)
      #log.info "Fine Node #{node.id}"

    ###############################################################################################
    ##### TODO: Complete
    ##### Checks if node is sibling of previous nodes. If yes, cut obsolete nodes from path #####
    ###############################################################################################
    cutCheck = (node) ->

      for key, value of allSiblingIds    # {pathIndex: }

        if blacklist.indexOf(key) > -1 then continue
        if ""+node.id == ""+key

          del = path.length - value
          wrongWay = 0
          #log.info("NextNode is a sibling of a previous node, removing obsolete")

          for [0...del]
            path.pop()
          break

    ###############################################################################################
    ##### Resets path, blacklist and increases max wrong ways with one #####
    ###############################################################################################
    expand = ->
      path = []
      blacklist = []
      allSiblingIds = {}
      path.push(start)
      blacklist.push(start.id)
      wrongWay = 0
      maxBacktrack += 1

    ###############################################################################################
    ##### Checks for illegal input #####
    ###############################################################################################
    preCheck = ->

      # Checking for bad maxBacktrack input
      if maxBacktrack < 1
        maxBacktrack = 1
        log.info("Max backtrack cant be 0, setting to 1")

      # Checking for bad escalations input
      if escalations < 0
        escalations = 0
        log.info("Escalations cant be 0, setting to 1")

    ###############################################################################################
    ##### Runs the pathfinding loop #####
    ###############################################################################################
    run = ( ->
      loop

        # Checking for pathfinding suicide. If found, reset and expanding maxBacktrack with one
        if path.length == 0
          log.info "No node added, maxWrongWays too small?"
          expand()

        currentId = path[path.length - 1].id
        current = table.findOne({id: currentId}).node
        nextNode = getBestSibling(current)

        #log.info "Current node: #{current.id}"
        #log.info "Nodes in path: #{path.length}"

        # If there is no acceptable paths then break
        if not nextNode and path.length <= 2
          expand()
          continue

        # If there is no next node (endpoint or blacklisted siblings)
        if not nextNode or not current
          reverse()
          continue

        # If wrongEay exceeds maxWrongWays then reverse and try again
        if wrongWay >= maxBacktrack
          reverse(wrongWay)
          wrongWay = 0
          log.info("Wrong ways more than #{maxBacktrack}, skipped back \n")
          continue

        # If next node is sibling of previous node
        #allSiblingIds = allSiblingIds.filter (id) -> id isnt current.id
        cutCheck(nextNode)

        # If next node is further away than current, register it wrong way.
        if getGoalDist(current) < getGoalDist(nextNode)
          wrongWay++

        # If nextNode is fine and not already in path, add to path
        if nextNode not in path
          addNode(nextNode)
          #log.info "Node #{path[path.length - 1].id} vs #{goal.id}\n"
        else
          expand(start)

        break if path[path.length - 1].id == goal.id
      return path
    )


    startBench = performance()
    preCheck()

    # Runs specified number of escalations and returns the shortest path
    for [-1...escalations]
      result = run()
      expand()
      if best == null
        best = result
      if result.length < best.length
        best = result

    log.info "Path found in: #{(performance() - startBench).toFixed(1)} ms"
    return best

  @toIdList = (solution) ->

    pathInt = []
    pathInt.push(node.id) for node in solution
    return pathInt

  @toDictionary = (solution) ->

    pairs = {}
    pairs[node.id] = node for node in solution
    return pairs

  @printSolution = (solution) ->

    log.info("=======================================")
    log.info("Path of nodes (#{solution.length}):")
    log.info("---------------------------------------")
    for node in solution
      log.info(node.id + " - " +node.name)
    log.info("=======================================")

module.exports = Pathfinder



"""
# Check siblings sibling (belongs to bStar)
        for sibling in current.siblings

          sib = table.findOne({id: sibling.id}).node
          bestSibling = current
          tmpBest = getBestSibling(sib)

          if tmpBest == null then continue

          if(getGoalDist(tmpBest) < getGoalDist(bestSibling))
            bestSibling = tmpBest
            nextNode = sibling
        addNode(nextNode)
"""