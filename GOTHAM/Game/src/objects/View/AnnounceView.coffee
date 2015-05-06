

###*
# View for the announcement messages
# @class AnnounceView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class AnnounceView extends Gotham.Pattern.MVC.View

  constructor: ->
    super


  create: ->

  # Starts a message
  # @param text [Gotham.Graphics.Text] The text object
  # @param callback [Callback] on complete callback
  startMessage: (text, callback) ->
    that = @

    @addChild text

    tween = new Gotham.Tween text
    tween.to {alpha: 1}, 2000
    tween.delay(2000)
    tween.to {alpha: 0}, 2000
    tween.onComplete () ->
      that.removeChild text
      callback()
    tween.start()



module.exports = AnnounceView