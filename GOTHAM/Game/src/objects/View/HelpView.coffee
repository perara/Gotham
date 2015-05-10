###*
# HelpView shows all help sections of the game.
# @class HelpView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class HelpView extends Gotham.Pattern.MVC.View


  ###*
  # Adds a help category
  # @method addCategory
  # @param {Object} category
  # @returns {JQUERY-DIV} The resulting jquery child div
  ###
  addCategory: (category, origSelector) ->
    selector = if not origSelector then $(@helpMenu) else origSelector

    # Menu Item Selector
    menuItem = $("<a/>",{
      "href": ".item-" + category.id,
      "data-toggle": "collapse",
      "text": category.title,
      "class": "list-group-item squared help-menu-item"
    })

    # Menu Children Container
    childrenContainer = $("<div/>",{
      "class": "collapse item-" + category.id
    })

    # Content Container
    contentContainer = $("<div/>", {
      "class": "help-content-item",
      "id": "content-" + category.id,
      "style": "display: none;"
    })
    $(contentContainer).html(category.text)


    # Click event for the menu item (To show the content)
    $(menuItem).on "click", ->
      $(".help-content-item").hide()
      $(contentContainer).show()









    selector.append(menuItem)
    selector.append(childrenContainer)
    $(@helpContent).append(contentContainer)


    return childrenContainer



  create: ->

    helpForm = $("<div/>",{
      "class": "help-form"
      "style": "position: absolute;
            top: 20%;
            left:20%;
            width: 600px;
            height: 400px;
            background-color: #fdf5e8;
            box-shadow: 10px 10px 5px #000000;
            border: 1px solid black;"
    })

    innerContainer = $("<div/>",{
      "style": "height: 100%;"
    })


    @helpMenu = $("<div/>",{
      "class": "col-sm-4 b-col help-menu"
      "style": "height: 100%;
            overflow-y: scroll;
            overflow-x: hidden;
            background-color: #FFFFFF;
            border-right: 1px solid #ddd;
            float: left;
            padding: 0;"
    })

    helpTitle = $("<div/>",{
      "class": "col-sm-7 help-title"
      "html": "<p>Help Central</p>"
      "style": "            height: 25px;
            text-align: center;
            font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif;
            font-size: 24px;
            font-style: normal;
            font-variant: normal;
            font-weight: 500;
            line-height: 26.3999996185303px;"
    })

    @helpContent = $("<div/>",{
      "class": "col-sm-7 help-content"
      "style": "padding: 10px;
            height: 90%;
            overflow: scroll;"
    })


    $("#help-section").append(helpForm)
    $(helpForm).append(innerContainer)
    $(innerContainer).append(@helpMenu)
    $(innerContainer).append(helpTitle)
    $(innerContainer).append(@helpContent)



  show: ->
    $("#help-section").show()
  hide: ->
    $("#help-section").hide()






module.exports = HelpView