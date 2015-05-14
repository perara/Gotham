Terminal = require './Terminal.coffee'



###*
# Console Class Contains all data of the console window, Acts much like an array, but have some extended functionality for easy data manipulation
# @class Console
# @module Frontend
# @submodule Frontend.Terminal
# @namespace GothamGame.Terminal
###
class Console

  constructor: ()->
    @_console = []
    @_history = []
    @_historyPointer = 0

  redraw: () ->

  getAt: (index) ->
    return @_console[index]

  all: () ->
    return @_console

  addAt: (index, text) ->
    @_console.splice index, 0, text

  appendTo: (index, text) ->
    @_console[index] += text

  add: (text) ->
    @_console.push text
    @redraw()


  addArray: (arr) ->
    for i in arr
      @add i

  addBefore: (text) ->
    @addAt 0, text

  clear: ->
    @_console.length = 0

  clearHistory: ->
    @_history.length = 0

  getHistory: ->
    return @_history

  getHistoryAt: (index) ->
    if @_history.length == 0
      return null
    return @_history[index %% @_history.length]

  addHistory: (command) ->
    @_history.push command
    @_historyPointer = @_history.length

  incrementHistoryPointer: (add) ->
    @_historyPointer+= add
    return @_historyPointer


module.exports = Console