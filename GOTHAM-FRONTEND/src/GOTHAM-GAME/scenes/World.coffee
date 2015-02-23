

class World extends Gotham.Graphics.Scene

  create: ->
    # Create Required Objects
    object_WorldMap = new GothamGame.objects.WorldMap
    object_WorldMap.position = {x : 225, y: 70}
    object_WorldMap.scale = {x : 0.8, y: 0.8}

    object_TopBar = new GothamGame.objects.TopBar



    # Add Objects to scene
    @.addObject object_TopBar
    @.addObject object_WorldMap




module.exports = World