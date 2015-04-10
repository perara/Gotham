
class StringTools


  @ObjectToString: (obj) ->
    str = ''
    for key, p of obj
      if obj.hasOwnProperty(p)
        str += p + '::' + obj[p] + '\n'
    return str


module.exports = StringTools