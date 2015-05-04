


class UserView extends Gotham.Pattern.MVC.View

  constructor: ->
    super

    @movable()
    @click = ->
      @bringToFront()



  create: ->
    @createFrame()
    @createTitles()


  createTitles: ->


  setUser: (user) ->





  show: ->
    @window.visible = true

  hide: ->
    @window.visible = false

  createFrame: ->

    # Create Window
    window = @window = new Gotham.Graphics.Sprite Gotham.Preload.fetch "user_management_background", "image"
    window.width = 800
    window.height = 700
    window.y = 1080 - 70 - 700
    window.interactive = true
    window.mousemove = (e)->

    #window.movable()

    # Create mask background
    windowMask = new Gotham.Graphics.Graphics
    windowMask.beginFill(0x232323, 1)
    windowMask.drawRect(0, 0,  window.width / window.scale.x, window.height / window.scale.y)
    window.addChild windowMask
    window.mask = windowMask

    # Create Frame
    frame = @frame = new Gotham.Graphics.Sprite Gotham.Preload.fetch "user_management_frame", "image"
    frame.width = window.width / window.scale.x
    frame.height = window.height / window.scale.y
    window.addChild frame

    return @addChild window











module.exports = UserView

