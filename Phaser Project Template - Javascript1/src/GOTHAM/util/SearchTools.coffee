# CoffeeScript

class SearchTools

  @FindKey: (object, key, maxDepth) ->
    if not maxDepth?
      maxDepth = 7

    # Iterative key search
    queue = []

    # Get Keys that belong to an object
    queue.push(object)

    found = undefined

    depth = 0
    while queue.length and not found
      
      if depth++ > maxDepth
        return null

      item = queue.shift()

      if key of item
        console.log "boud!"
        found = item[key]

      if typeof item == 'object'
        for _key of item
          queue.push(item[_key])

    return found
        






module.exports = SearchTools