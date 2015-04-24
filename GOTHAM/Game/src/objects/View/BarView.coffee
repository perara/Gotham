




class BarView extends Gotham.Pattern.MVC.View

  Bar:
    Top: undefined
    Bottom: undefined

  constructor: ->

    super


  create: ->
    @create_TopBar()
    @create_BottomBar()



  create_TopBar: ->
    texture_topBar = Gotham.Preload.fetch("topBar", "image")
    @Bar.Top = topBar = new Gotham.Graphics.Sprite texture_topBar
    @Bar.Top._left = []
    @Bar.Top._right = []
    topBar.position.x = 0
    topBar.position.y = 0
    topBar.width = 1920
    topBar.height = 70
    @addChild topBar

  create_BottomBar: ->
    texture_bottomBar = Gotham.Preload.fetch("bottomBar", "image")
    @Bar.Bottom = bottomBar = new Gotham.Graphics.Sprite texture_bottomBar
    @Bar.Bottom._left = []
    @Bar.Bottom._right = []
    bottomBar.width = 1920
    bottomBar.height = 70
    bottomBar.position.x = 0
    bottomBar.position.y = 1080 - bottomBar.height
    @addChild bottomBar

    """
    # Create LAT long text
    @coordinateText = new Gotham.Graphics.Text("Lat: 0\nLng: 0", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
    @coordinateText.position.x = topBar.width/2
    @coordinateText.position.y = 0
    @coordinateText.anchor =
      x: 0
      y: 0
    @addChild(@coordinateText)

    # Create LAT long text
    @countryText = new Gotham.Graphics.Text("Country: None", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
    @countryText.position.x = topBar.width/2 + 150
    @countryText.position.y = 15
    @countryText.anchor =
      x: 0
      y: 0
    @addChild(@countryText)



    button_terminal = new Gotham.Controls.Button "Terminal" , 50, 75
    button_terminal.toggleOn = (e) ->
      that.parent.getObject("Terminal").Show()
    button_terminal.toggleOff = (e) ->
      that.parent.getObject("Terminal").Hide()



    bottomBar.addChild button_terminal
    """


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