class Set

  constructor: ->
    @_list = {}

  push: (item) ->
    @_list[item] = null
    return item

  pop: ->
    keys = Object.keys(@_list)
    obj = @_list[keys.length - 1]
    delete @_list[obj]
    return obj

module.exports = Set