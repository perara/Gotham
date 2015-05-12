


###*
# ShopView is the view of the shop in the game. Possible top purchase networks etc.
# @class ShopView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class ShopView extends Gotham.Pattern.MVC.View


  create: ->

    @categories = []


    @movable()
    @createFrame()
    @createTitles()


  createFrame: ->
    # Frame of the panel
    @frame = new Gotham.Graphics.Sprite Gotham.Preload.fetch("shop_background", "image")
    @frame.width = 1920 * 0.30
    @frame.height = 1080 * 0.30
    @frame.x = 1920 * 0.33
    @frame.y = 1080 * 0.33
    @frame.interactive = true
    @addChild @frame

  createTitles: ->
    title = new Gotham.Graphics.Text("Dell Computer Shop", {font: "bold 150px calibri", fill: "#ffffff", stroke: "#000000", strokeThickness: 5, align: "center"});
    title.x = 350
    title.y = 60
    @frame.addChild(title)

  createCategory: (name, helpText, y, price, onClick = ->) ->

    title = new Gotham.Graphics.Text("Buy #{name} for " , {font: "bold 100px calibri", fill: "#ffffff", align: "center"});
    title.x = 400
    title.y = y
    @frame.addChild title

    help = new Gotham.Graphics.Text(helpText , {font: "bold 50px calibri", fill: "#ffffff", align: "center"});
    help.x = 400
    help.y = y + 100
    @frame.addChild help

    price = new Gotham.Graphics.Text("#{price}$" , {font: "bold 130px calibri", fill: "#006400", stroke: "#323232", strokeThickness: 10,  align: "center"});
    price.x = title.x + title.width + 10
    price.y = y - 20
    @frame.addChild price

    buyButton = new Gotham.Controls.Button "X" , 70, 70, {margin: 0, alpha: 1, textSize: 120, toggle:true, buttonColor: 0xF0F8FF}
    buyButton.x = title.x - 90
    buyButton.y = y + 20
    buyButton.interactive = true
    buyButton.tint = 0x4169E1
    buyButton.click = ->
      @toggle = if not @toggle then true else !@toggle
      if @toggle
        onClick(@, true)
        buyButton.tint = 0xFF0000
      else
        onClick(@, false)
        buyButton.tint = 0x4169E1


    @frame.addChild buyButton








  show: ->
    @visible = true

  hide: ->
    @visible = false

module.exports = ShopView