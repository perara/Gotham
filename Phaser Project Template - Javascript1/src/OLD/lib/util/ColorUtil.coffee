# CoffeeScript


class ColorUtil

  constructor: () ->
  @HexColor: ->                                                  
    return ((0.5 + 0.5*Math.random())*0xFFFFFF<<0).toString(16);




module.exports = ColorUtil