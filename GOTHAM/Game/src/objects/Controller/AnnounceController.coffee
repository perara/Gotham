View = require '../View/AnnounceView.coffee'

###*
# AnnounceController, This controller handles the Announcement which turn up on middle of the screen. Used in Mission for example
# @class AnnounceController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
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
    GothamGame.Network.Socket.on 'ANNOUNCE', (data) ->
      that.message(data.message, data.type, 40)


  message: (message, type, size) ->
    size = if not size then "100" else size
    type = if not type then "NORMAL" else type

    color = null
    stroke = null
    if type == "NORMAL"
      color = "#FFFFFF"
      stroke = "#000000"
    else if type == "ERROR"
      color = "#FF0000"
      stroke = "#000000"
    else if type == "MISSION"
      color = "#004600"
      stroke = "#FFFFFF"
    else
      color = "#000000"



    message = new Gotham.Graphics.Text(message, {font: "bold #{size}px calibri", stroke: stroke, strokeThickness: 4, fill: color, align: "center", dropShadow: true});
    message.x = (1920/2)
    message.y = (1080/6)
    message.anchor =
      x: 0.5
      y: 0.5
    message.alpha = 1
    message.visible = true

    container = new Gotham.Graphics.Graphics()
    container.beginFill "#000000", 0.5
    container.drawRect (1920/2) - (message.width/2) ,(1080/6) - (message.height/2) ,message.width, message.height


    container.addChild message

    @messageQueue.push container

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