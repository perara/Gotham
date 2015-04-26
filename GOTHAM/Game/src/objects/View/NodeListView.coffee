


class NodeListView extends Gotham.Pattern.MVC.View


  constructor: ->
    super
    that = @

    # Currently Selected Node
    @_selected = null

    # Currently Start index scrolled to
    @_scrollIndex = 0

    # Number of visible nodes
    @_maxVisible = 7

    # Number of total nodes
    @_nodeCount = 0


  create: ->
    that = @

    # Create Frame
    frame = new Gotham.Graphics.Sprite Gotham.Preload.fetch("terminal_background", "image")
    frame.width = 250 * frame.scale.x
    frame.height = 600 * frame.scale.y
    @addChild frame

    @movable()



    # Create Object Title text
    object_name = new Gotham.Graphics.Text("Node List", {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
    object_name.position.x =  @width / 2
    object_name.position.y = 10
    object_name.anchor.x = 0.5
    @addChild object_name


    # Create Window Background
    background = new Gotham.Graphics.Sprite Gotham.Preload.fetch("nodelist_background", "image")
    background.x = 0
    background.y = 50
    background.width = 250 * background.scale.x
    background.height = 530
    background.setInteractive true
    @addChild background
    GothamGame.Renderer.pixi.addWheelScrollObject(background)

  create_frame: ->
    

  create_item: () ->

    # Create Node Entries in the bg window
    drawNodeItems = () ->
      # Remove all previous node item children
      for child in background.children
        background.removeChild child

      count = 0

      # Fetch Node Table
      db_node = GothamGame.Database.table "node"

      # Update NodeCount
      that._nodeCount = db_node().count()

      # Update GUI
      db_node()
      .start(that._scrollIndex)
      .limit(that._maxVisible)
      .each (row) ->
        # Create Node Background
        node_item_background = new Gotham.Graphics.Sprite Gotham.Preload.fetch("bottomBar", "image")
        node_item_background.height = (background.height / background.scale.y)/ that._maxVisible
        node_item_background.width = background.width / background.scale.x
        node_item_background.y = (node_item_background.height * count++)
        node_item_background.setInteractive true

        # Create Node Marker
        node_marker = new Gotham.Graphics.Sprite Gotham.Preload.fetch("map_marker", "image")
        node_marker.height = 32 / node_item_background.scale.y
        node_marker.width = 32 / node_item_background.scale.x
        node_marker.x = 10 / node_item_background.scale.x
        node_marker.y = (node_item_background.height / 2) / node_item_background.scale.y
        node_marker.anchor.y = 0.5
        node_item_background.addChild node_marker

        # Create Name Text
        node_name = new Gotham.Graphics.Text((if row.Name.length > 20 then row.name.substring(0,20) + "..." else row.Name), {font: "bold 20px Arial", fill: "#ffffff", align: "left"});
        node_name.width = node_item_background.width / node_item_background.scale.x
        node_name.position.x =  node_marker.width  + (node_marker.y)
        node_name.position.y = (node_item_background.height / 2) / node_item_background.scale.y
        node_name.anchor.y = 0.4
        node_item_background.addChild node_name

        # Create Tier Text
        node_tier = new Gotham.Graphics.Text("Tier " + row.Tier.Id, {font: "bold 15px Arial", fill: "#3399ff", align: "left"});
        node_tier.width = node_item_background.width / node_item_background.scale.x
        node_tier.position.x =  (node_item_background.width / node_item_background.scale.x) -  node_tier.width
        node_tier.position.y = 10 / node_item_background.scale.y
        node_item_background.addChild node_tier

        node_item_background.click = (e) ->
          @_clickToggle = !@_clickToggle

          if @_clickToggle
            row.sprite.mouseover(e)
            node_marker.tint = row.sprite.tint = 0xffff00
            row.sprite.scale.x = row.sprite.scale.x * 2
            row.sprite.scale.y = row.sprite.scale.y * 2
          else
            row.sprite.mouseout(e)
            node_marker.tint = row.sprite.tint = 0xffffff
            row.sprite.scale.x = row.sprite.scale.x / 2
            row.sprite.scale.y = row.sprite.scale.y / 2


        # Finally add the node item
        background.addChild node_item_background

    # Draw the node items initially
    drawNodeItems()


    background.mouseover = () ->
      @canScroll = true
    background.mouseout = () ->
      @canScroll = false
    background.onWheelScroll = (e) ->
      if not @canScroll then return
      direction = (e.wheelDeltaY / Math.abs(e.wheelDeltaY)) * -1
      if direction + that._scrollIndex < 0 then return
      if direction + that._scrollIndex > (that._nodeCount - that._maxVisible + 1) then return
      that._scrollIndex += direction
      # Redraw Items
      drawNodeItems()



















    @addChild background




module.exports = NodeListView