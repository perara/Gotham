
class StringTools


  @ObjectToString: (obj) ->
    str = ''
    for key, p of obj
      if obj.hasOwnProperty(p)
        str += p + '::' + obj[p] + '\n'
    return str

  @Resolve = (obj, path, def, setValue) ->
    i = undefined
    len = undefined
    previous = obj
    i = 0
    path = path.split('.')
    len = path.length

    while i < len
      if !obj or typeof obj != 'object'
        return def

      previous = obj
      obj = obj[path[i]]
      i++

    if obj == undefined
      return def

    # If setValue is set, set the returning value to something
    if setValue
      previous[path[len-1]] = setValue

    return obj


module.exports = StringTools