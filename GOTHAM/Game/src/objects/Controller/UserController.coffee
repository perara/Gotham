View = require '../View/UserView.coffee'

###*
# Manages data which is to be drawn on the UserView
# @class UserController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class UserController extends Gotham.Pattern.MVC.Controller

  constructor: (name) ->
    super View, name

  create: ->
    #@hide()

    @setupUser()

  setupUser: ->
    db_user = Gotham.Database.table "user"


    @View.setUser(db_user.data[0])



  addMoney: ->

  show: ->
    @View.show()

  hide: ->
    @View.hide()



module.exports = UserController



