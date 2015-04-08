




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
    topBar.position.x = 0
    topBar.position.y = 0
    topBar.width = 1920
    topBar.height = 70
    @addChild topBar

  create_BottomBar: ->
    texture_bottomBar = Gotham.Preload.fetch("bottomBar", "image")
    @Bar.Bottom = bottomBar = new Gotham.Graphics.Sprite texture_bottomBar
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
  addItem: (bar, callback) ->

    # Get last element added to the bar
    lastElement = bar.children.last()


    # Calculate X position of the button
    x = if not lastElement then 0 else lastElement.x + lastElement.width
    margin = if not lastElement then 0 else (if lastElement.margin then lastElement.margin else 0)

    child = bar.addChild callback()

    child.y = 0
    child.x = x + 5 + margin





module.exports = BarView