


###*
# The World Scene is the Main Game Scene. All objects of the game is created here.
# @class World
# @module Frontend.Scenes
# @namespace GothamGame.Scenes
# @extends Gotham.Graphics.Scene
###
class World extends Gotham.Graphics.Scene

  create: ->


    WorldMap = new GothamGame.Controllers.WorldMap "WorldMap"
    @addObject WorldMap

    Bar = new GothamGame.Controllers.Bar "Bar"
    @addObject Bar

    IdentityManagement = new GothamGame.Controllers.Identity "Identity"
    @addObject IdentityManagement

    UserManagement = new GothamGame.Controllers.User "User"
    @addObject UserManagement

    NodeList = new GothamGame.Controllers.NodeList "NodeList"
    @addObject NodeList

    Mission = new GothamGame.Controllers.Mission "Mission"
    @addObject Mission

    Shop = new GothamGame.Controllers.Shop "Shop"
    @addObject Shop

    Gothshark = new GothamGame.Controllers.Gothshark "Gothshark"
    @addObject Gothshark

    # Add the Announce Module
    @addObject GothamGame.Announce


module.exports = World