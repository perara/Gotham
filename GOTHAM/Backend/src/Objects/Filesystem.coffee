'use strict'



class Filesystem


  constructor: ->
    @_rawData = null
    @_filesystem = {
      children:
        'fil1':
          extension: 'txt'
        'fil2':
          extension: 'txt'
        'fil3':
          extension: 'mpg'
        'dir1':
          extension: 'dir'
          children:
            'fil12':
              extension: 'txt'
            'dir2':
              extension: 'dir'
              children:
                'dir3':
                  extension: 'dir'


    }

  Parse: (json)->
    @_rawData = json
    @_filesystem = JSON.parse(json)

  Get: ->
    return @_filesystem


module.exports = Filesystem



