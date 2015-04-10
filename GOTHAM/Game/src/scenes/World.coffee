

class World extends Gotham.Graphics.Scene

  create: ->
    that = @

    Bar = new GothamGame.Controllers.Bar "Bar"
    @addObject Bar

    WorldMap = new GothamGame.Controllers.WorldMap "WorldMap"
    @addObject WorldMap

    Terminal = new GothamGame.Controllers.Terminal "Terminal"
    @addObject Terminal

    NodeList = new GothamGame.Controllers.NodeList "NodeList"
    @addObject NodeList




    # Create the World Map Object
    """object_WorldMap = new GothamGame.objects.WorldMap
    object_WorldMap.position = {x : 225, y: 70}
    object_WorldMap.scale = {x : 0.8, y: 0.8}

    # Create the Top Bar Object
    object_TopBar = new GothamGame.objects.TopBar

    # Create the NodeList Object
    object_NodeList = new GothamGame.objects.NodeList

    # Create the Terminal Object
    object_Terminal = new GothamGame.objects.Terminal
    object_Terminal.Show();





    # Add Objects to scene
    @.addObject object_TopBar
    @.addObject object_WorldMap
    @.addObject object_Terminal

    @Callbacks.onNodesLoaded = ->
      that.addObject object_NodeList
    """



module.exports = World