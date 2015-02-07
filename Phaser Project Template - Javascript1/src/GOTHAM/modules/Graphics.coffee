# CoffeeScript
Polygon = require './Graphics/Polygon.coffee'
Rectangle = require './Graphics/Rectangle.coffee'


class Graphics

  constructor: ->
    @Polygon = Polygon
    @Rectangle = Rectangle


module.exports = new Graphics()