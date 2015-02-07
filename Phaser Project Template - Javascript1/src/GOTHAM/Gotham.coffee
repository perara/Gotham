# CoffeeScript

# Third Party
Howler      =     require "./dependencies/howler.js"


# 
Sound       =     require "./modules/Sound.coffee" 
Tween       =     require "./modules/Tween.coffee"
Graphics    =     require "./modules/Graphics.coffee"
Preload     =     require "./modules/Preload.coffee"

class Gotham
  constructor: ->
    # Third Party
    @_Howler = Howler


    # Modules
    @Sound = new Sound(@)
    @Graphics = Graphics
    @Tween = Tween
    @Preload = new Preload(@)
   



module.exports = new Gotham()

