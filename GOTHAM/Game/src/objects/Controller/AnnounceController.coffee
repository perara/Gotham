View = require '../View/AnnounceView.coffee'

###*
# AnnounceController, This controller handles the Announcement which turn up on middle of the screen. Used in Mission for example
# @class AnnounceController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
###
class AnnounceController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

    @isWaiting = false
    @messageQueue = []

  create: ->
    @queue()
    @networkMessages()

  networkMessages: ->
    that = @
    GothamGame.Network.Socket.on 'ERROR', (data) ->
      that.message(data.message, "ERROR", 40)


  message: (message, type, size) ->
    size = if not size then "100" else size
    type = if not type then "NORMAL" else type

    color = null
    if type == "NORMAL"
      color = "#FFFFFF"
    else if type == "ERROR"
      color = "#FF0000"
    else if type == "MISSION"
      color = "#FCC200"
    else
      color = "#000000"


    message = new Gotham.Graphics.Text(message, {font: "bold #{size}px calibri", fill: color, align: "center"});
    message.x = 1920 / 2
    message.y = 1080 / 6
    message.anchor =
      x: 0.5
      y: 0.5
    message.alpha = 0
    message.visible = true

    @messageQueue.push message

  queue: ->
    that = @

    id = setInterval (() ->

      # Contains any messages
      if that.messageQueue.length > 0
        if not that.isWaiting
          that.isWaiting = true
          message = that.messageQueue.shift()
          that.View.startMessage message, ->
            that.isWaiting = false
            that.queue()
          clearInterval(id)
    ),200

module.exports = AnnounceController