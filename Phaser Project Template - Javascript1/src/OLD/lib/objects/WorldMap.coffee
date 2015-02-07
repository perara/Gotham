# CoffeeScript


class WorldMap

  constructor: (game) ->
    @game = game
    @create()

  create: ->
    game = @game
    # Colors
    color = [0xFF33ff, 0xFF3333, 0x3d838a, 0x3399ff, 0x2EEEA3]

    # Create group for all sprites
    mapGroup = @game.add.sprite()
    


    
    # Load Polygon List
    $.getJSON "assets/json/json.json", (data) ->

      # Iterate through each of the polygons
      $.each data, (key, polygon) ->

        count = 0;
        newarr = []


        # Each point of the polygon
        $.each polygon, (key, item) ->
        
          if (count++ % 20 == 0)
            polygon[key]["x"] = polygon[key]["x"] / 5
            polygon[key]["y"] = polygon[key]["y"] / 5
            newarr.push(polygon[key])
          

        
        p = new Phaser.Polygon(newarr);
        
        

        country = new Phaser.Graphics(@game)
        country.lineStyle(2, 0x0000FF, 1);
        country.beginFill(color[Math.floor((Math.random() * color.length))]);
        country.drawPolygon(p.points);
        country.endFill();
        
  
        sprite = game.add.sprite(0, 0);
        
        sprite.hitArea = newarr
        sprite.inputEnabled = true;
        sprite.interactive = true

        # Animation which Glows Border of the object
        glowOn = (object, mouse) ->
          #TODO
          object.children[0].scale = 0
          object.rotation = 100
          console.log(object)
  
          
              

        #sprite.events.onInputDown.add(listener,this); # Click
        sprite.events.onInputOver.add(glowOn, this); # HoverStart
        sprite.events.onInputOut.add(glowOn, this); #HoverOut
    
 
        sprite.addChild(country)
        mapGroup.addChild(sprite)










module.exports = WorldMap