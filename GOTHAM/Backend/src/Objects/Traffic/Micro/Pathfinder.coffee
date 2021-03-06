GeoTool = require '../../../Tools/GeoTool.coffee'
performance = require 'performance-now'
log = require('log4js').getLogger("Pathfinder")


class Pathfinder


  ###############################################################################################
  ##### Tries random paths and returns the shortest that reached the goal
  ###############################################################################################
  @tryRandom = (start, goal, blacklistIDs, maxLength = 50, tryPaths = 100000) ->

    # Set starting values
    sum = 0
    minPath = Number.MAX_VALUE
    path = []
    tries = 0
    blacklist = blacklistIDs

    # Method used for finding a number between min and max
    rnd = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min

    startTime = performance()

    # Try finding a path a specific number of times (tryPaths)
    while (tries < tryPaths)

      # Setting up values for a single path
      queue = []
      currentNode = start
      jumps = 0
      queue.push(start)

      # Traversing through a path finding random routes
      loop

        siblings = currentNode.getSiblings()
        nextNode = siblings[rnd(0, siblings.length - 1)]

        if nextNode.id in blacklist then continue

        deltaTime = new Date().getTime()
        sum += (new Date().getTime() - deltaTime)
        queue.push(nextNode)
        currentNode = nextNode
        jumps++

        # Should the goal be reached or path be longer than maxLength
        break if currentNode.id == goal.id or jumps > maxLength

      # Checks if the new path is shorter than the best path.
      if currentNode == goal and queue.length < minPath
        path = queue;
        minPath = queue.length;
        #console.log "found new path"

      tries++

    #console.log ("Pathfinding: #{(performance() - startTime)} ms --- Deltatime: " + sum)

    return path


  ###############################################################################################
  ##### Uses geometric locations of siblings to generate a path
  ###############################################################################################
  @aStar: (start, goal, blacklistIDs) ->

    # Set starting values
    maxPathLength = 100
    path = []
    blacklist = blacklistIDs
    path.push(start)
    blacklist.push(start.id)

    # Function for reversing, should a node be bad
    reverse = (node) ->
      blacklist.push(node.id)
      path.pop()

    # Adding a good node to the path and preventing it from being used again
    addNode = (node) ->
      path.push(node)
      blacklist.push(node.id)

    # Starts the benchmarking tool and then the loop for finding a path
    start = performance()
    loop

      # Getting the current node and finding the sibling closest to the goal
      current = path[path.length - 1]
      nextNode = GeoTool.getClosest(goal, current.getSiblings(), blacklist)
      wrongWay = 0

      log.info "Current node: #{current.id}"
      log.info "Nodes in path: #{path.length}"

      # Different checks for optimizations and error
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

      #log.info "Node #{path[path.length - 1].id} vs #{goal.id}\n"

      break if path[path.length - 1].id == goal.id or path.length > maxPathLength

    #log.info "Path found in: #{performance() - start} ms"
    return path

  ####################################################################################################################
  ####################################################################################################################
  ##### Improvement of aStar, supports reversing and removal of obsolete nodes #######################################
  ####################################################################################################################
  ####################################################################################################################
  @bStar: (_start, _goal, blacklistIDs, startBacktrack = 1, escalations = 2, _onError = ->) ->

    start = _start
    goal = _goal

    # Declarations
    path = []
    blacklist = [].concat(blacklistIDs)
    allSiblings = {}
    path.push(start)
    blacklist.push(start)
    wrongWay = 0
    best = null
    maxBacktrack = startBacktrack
    deltaTime = 0
    isReverse = false

    ################################################################################################
    ##### Returns sibling closest to goal (gets siblings list from input node) #####################
    ################################################################################################

    getBestSibling = (current) ->
      bestSibling = GeoTool.getClosest(goal, current.getSiblings(), blacklist)

      if not bestSibling
        return null

      for sibling in current.getSiblings()

        if bestSibling.id == sibling.id then continue
        allSiblings[sibling.id] = path.length

      return GeoTool.getClosest(goal, current.getSiblings(), blacklist)

    ###############################################################################################
    ##### Sets the goals sibling to current coal
    ###############################################################################################

    changeDirection = () ->
      goal = _start
      start = _goal
      isReverse = if isReverse then false else true
      reset()

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
        path.pop()
        for key, value of allSiblings
          if value == pathLength
            delete allSiblings[key]
        #log.info "Foul Node #{removed.id}"

    ###############################################################################################
    ##### Adds i fine node
    ###############################################################################################
    addNode = (node) ->
      path.push(node)
      blacklist.push(node)
      #log.info "Fine Node #{node.id}"

    ###############################################################################################
    ##### Checks if node is sibling of previous nodes. If yes, cut obsolete nodes from path #####
    ###############################################################################################
    cutCheck = (node) ->

      for key, value of allSiblings    # {pathIndex: }

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
      tempBT = maxBacktrack
      reset()
      maxBacktrack = tempBT += 1

    ###############################################################################################
    ##### Resets path, blacklist #####
    ###############################################################################################
    reset = ->
      path = []
      blacklist = [].concat(blacklistIDs)
      allSiblings = {}
      path.push(start)
      blacklist.push(start)
      wrongWay = 0
      maxBacktrack = startBacktrack

    ###############################################################################################
    ##### Checks for illegal input, returns false if path contains illegal input #####
    ###############################################################################################
    preCheck = ->

      # Check if start and goal is the same
      if start.id == goal.id
        log.info("Start and goal is on the same node, no need for pathfinding")
        return false

      # Checking for bad maxBacktrack input
      if maxBacktrack < 1
        maxBacktrack = 1
        log.info("Max backtrack cant be 0, setting to 1")

      # Checking for bad escalations input
      if escalations < 0
        escalations = 0
        log.info("Escalations cant be 0, setting to 1")

      return true

    ###############################################################################################
    ##### Runs the pathfinding loop #####
    ###############################################################################################
    run = ( ->
      loop
        deltaTime = new Date().getTime() - startTime
        if deltaTime > 500
          log.info("Pathfinder timed out. Check if path is valid")
          _onError(_start.id, _goal.id)
          deltaTime = 0
          return

        # Checking for pathfinding suicide. If found, reset and expanding maxBacktrack with one
        if path.length == 0
          #log.info "No node added, maxWrongWays too small?"
          expand()

          #changeDirection()

        current = path[path.length - 1]
        nextNode = getBestSibling(current)

        # If there is no siblings (Reached end)
        if not nextNode
          #console.log path.map (node) ->
          #  return node.id
          reverse()
          continue

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
          #log.info("Wrong ways more than #{maxBacktrack}, skipped back \n")
          continue

        # If next node is sibling of previous node
        #allSiblings = allSiblings.filter (id) -> id is not current.id
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

        break if path[path.length - 1] == goal
      return path
    )

    # Starting benchmark and running pre check.
    startTime = new Date().getTime()
    if not preCheck() then return


    # Runs specified number of escalations and returns the shortest path
    for [-1...escalations]
      changeDirection()
      result = run()

      if not result then continue
      if isReverse then result.reverse()
      if not best then best = result
      if result.length < best.length
        best = result


    #log.info "Path found in: #{(deltaTime).toFixed(1)} ms"
    return best

  # Converts a list of nodes to a list of IDs
  @toIdList = (solution) ->

    pathInt = []
    pathInt.push(node.id) for node in solution
    return pathInt

  # Converts a list of nodes to a dictionary with node.id as key
  @toDictionary = (solution) ->

    pairs = {}
    pairs[node.id] = node for node in solution
    return pairs

  # Prints out the id and name of each node in the list
  @printSolution = (solution) ->

    log.info("=======================================")
    log.info("Path of nodes (#{solution.length}):")
    log.info("---------------------------------------")
    for node in solution
      log.info(node.id + " - " +node.name)
    log.info("=======================================")

module.exports = Pathfinder
