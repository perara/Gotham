# CoffeeScript
SearchTools = require '../util/SearchTools.coffee'


class Preload

  constructor: (Gotham) ->
    @_Gotham = Gotham
    @_totalObjects = 0
    @_loadedObjects = 0
    @_callback = ->
  
    # Storage container
    @storage = 
      audio: []
      video: []
      image: []

    # Private Members
    @imageFromUrl = (url, name) ->
      that = @
      img = new Image()
      img.src = url
      img._name = name
      img.onload = ->
        that._loadedObjects++
        # URL, Name, Percent
        that._callback(@src, @_name, (that._loadedObjects / that._totalObjects ) * 100.0)

    @soundFromUrl = (item, name, options) ->
      that = @

      # HowlerJS Parameters
      howlParameters =   
        urls: [item]
        onload : ->
          that._loadedObjects++
          that._callback(@_src, @_name, (that._loadedObjects / that._totalObjects ) * 100.0)
    
      # If Option is set, merge with Howler.js options
      if options?
        howlParameters.merge(options)

      # Load the Sound
      sound = new Howl(howlParameters)
      sound._name = name
  
      return sound
  

  onLoad: (callback) ->
    @_callback = callback


  image: (item, name, options) -> 
    @_totalObjects++
    @getType("image")[name] = @imageFromUrl(item, name)

  mp3: (item, name, options) -> 
    @_totalObjects++
    @getType("audio")[name] = @soundFromUrl(item, name, options)
   
    


  fetch: (name, type) ->
    
    # If no type is defined, attempt to find. (Give warning)
    if not type?
      console.log "Optimization potential detected: Define Type"
      return SearchTools.FindKey(@storage, name)


  getType: (type) ->
    switch type
      when "image"
        return @storage.image
      when "audio" 
        return @storage.audio
      else
        throw new Error "Format Not Supported, Preload"


      

    return @storage
  

  

  




module.exports = Preload