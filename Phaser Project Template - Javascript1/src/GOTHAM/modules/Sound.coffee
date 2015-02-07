# CoffeeScript
Howler = require '../dependencies/howler.js'

class Sound

  constructor: (Gotham) ->
    @Gotham = Gotham
  
  play: (name) ->
    @Gotham.Preload.fetch(name).play()

  stop: (name) ->
    @Gotham.Preload.fetch(name).stop()

  pause: (name) ->
    @Gotham.Preload.fetch(name).pause()

  volume: (name, val) ->
    @Gotham.Preload.fetch(name).volume(val)
 
  forward: (name, sec) ->
    currPos = @Gotham.Preload.fetch(name).pos()
    @Gotham.Preload.fetch(name).pos(currPos + sec)

  backward: (name, sec) ->
    currPos = @Gotham.Preload.fetch(name).pos()
    @Gotham.Preload.fetch(name).pos(currPos - sec)

  mute: (name) ->
    @Gotham.Preload.fetch(name).mute()

  unmute: (name) ->
    @Gotham.Preload.fetch(name).unmute()
  




module.exports = Sound