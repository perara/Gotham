class BaseLayer
  constructor: ->
    @type = @setType()

  setType: ->
    throw new Error "Must be overrided"


module exports = BaseLayer