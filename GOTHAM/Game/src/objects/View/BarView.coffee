




class BarView extends Gotham.Pattern.MVC.View

  Bar:
    Top: undefined
    Bottom: undefined
    Side:
      Left: undefined

  constructor: ->

    super


  create: ->
    @create_topBar()
    @create_sideBar()
    #@create_bottomBar()




  create_sideBar: ->
    texture_side_left = Gotham.Preload.fetch("sidebar", "image")
    @Bar.Side.Left = new Gotham.Graphics.Sprite texture_side_left
    @Bar.Side.Left.y = 80
    @Bar.Side.Left.x = 10
    @Bar.Side.Left.width = 70
    @Bar.Side.Left.height = 1080
    @addChild @Bar.Side.Left


  create_topBar: ->
    texture_topBar = Gotham.Preload.fetch("topBar", "image")
    @Bar.Top = topBar = new Gotham.Graphics.Sprite texture_topBar
    @Bar.Top._left = []
    @Bar.Top._right = []
    topBar.position.x = 0
    topBar.position.y = 0
    topBar.width = 1920
    topBar.height = 70
    @addChild topBar

  createBottomBar: ->
    texture_bottomBar = Gotham.Preload.fetch("bottomBar", "image")
    @Bar.Bottom = bottomBar = new Gotham.Graphics.Sprite texture_bottomBar
    @Bar.Bottom._left = []
    @Bar.Bottom._right = []
    bottomBar.width = 1920
    bottomBar.height = 70
    bottomBar.position.x = 0
    bottomBar.position.y = 1080 - bottomBar.height
    @addChild bottomBar


  addSidebarItem: (margin, callback) ->

    newItem = callback()

    # Find largest Y value with the "valign"
    lastElement = null
    for _ch in  @Bar.Side.Left.children
      if not lastElement
        lastElement = _ch
        continue

      if _ch.y > lastElement.y
          lastElement = _ch


    # If no lastElement (Empty)
    if not lastElement
      newItem.y = 10
      @Bar.Side.Left.addChild newItem
      return

    newItem.y = lastElement.y + lastElement.height + margin
    @Bar.Side.Left.addChild newItem





  # Adds a item to the specified bar
  # @param [Bar] location - Which bar to append to
  # @param [callback] callback - A callback which MUST RETURN the item to add to the menu
  #
  addItem: (bar, align, callback) ->

    if align == "LEFT"

      childArray = bar._left
      lastElement = childArray.last()
      child = callback()
      x = if lastElement then lastElement.x + lastElement.width + 5 else 0



    else if align == "RIGHT"
      childArray = bar._right
      lastElement = childArray.last()
      child = callback()
      x = if lastElement then lastElement.x - lastElement.width - 5 else (bar.width / bar.scale.x) - child.width

    else
      throw new Error "No Valid Alignment set in addItem"

    bar.addChild child
    childArray.push child

    child.y = 0
    child.x = x + child.margin

    return child



module.exports = BarView