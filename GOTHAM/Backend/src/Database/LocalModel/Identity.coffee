GothamObject = require './GothamObject.coffee'

###*
# Identity, A Identity represents a Person in the Game. A identity can be used by a user.
# @class Identity
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Identity extends GothamObject

  constructor: (model) ->
    super(model)

  ###*
  # Get the User Model for this Identity
  # @method getUser
  # @return {User}
  ###
  getUser: ->
    if not @User
      db_user = Gotham.LocalDatabase.table("User")
      @User = db_user.findOne({id: @fk_user})
    return @User

  ###*
  # Get all associated Network Models associated with this Identity
  # @method getNetworks
  # @return {Network[]}
  ###
  getNetworks: ->
    if not @Networks
      db_network = Gotham.LocalDatabase.table("Network")
      @Networks = db_network.find({identity: @id})
    return @Networks


###*
# The id of the identity
# @property {Integer} id
###
###*
# The fk_user of the identity
# @property {Integer} fk_user
###
###*
# The active of the identity
# @property {Boolean} active
###
###*
# The gender of the identity
# @property {String} gender
###
###*
# The nameset of the identity
# @property {String} nameset
###
###*
# The title of the identity
# @property {String} title
###
###*
# The first_name of the identity
# @property {String} first_name
###
###*
# The middleinitial of the identity
# @property {String} middleinitial
###
###*
# The last_name of the identity
# @property {String} last_name
###
###*
# The address of the identity
# @property {String} address
###
###*
# The city of the identity
# @property {String} city
###
###*
# The state of the identity
# @property {String} state
###
###*
# The zipcode of the identity
# @property {String} zipcode
###
###*
# The country of the identity
# @property {String} country
###
###*
# The countryfull of the identity
# @property {String} countryfull
###
###*
# The email of the identity
# @property {String} email
###
###*
# The username of the identity
# @property {String} username
###
###*
# The password of the identity
# @property {String} password
###
###*
# The telephonenumber of the identity
# @property {String} telephonenumber
###
###*
# The maidenname of the identity
# @property {String} maidenname
###
###*
# The birthday of the identity
# @property {String} birthday
###
###*
# The cctype of the identity
# @property {String} cctype
###
###*
# The ccnumber of the identity
# @property {String} ccnumber
###
###*
# The CVV2 of the identity
# @property {String} CVV2
###
###*
# The ccexpires of the identity
# @property {String} ccexpires
###
###*
# The nationalid of the identity
# @property {String} nationalid
###
###*
# The color of the identity
# @property {String} color
###
###*
# The occupation of the identity
# @property {String} occupation
###
###*
# The company of the identity
# @property {String} company
###
###*
# The vehicle of the identity
# @property {String} vehicle
###
###*
# The domain of the identity
# @property {String} domain
###
###*
# The bloodtype of the identity
# @property {String} bloodtype
###
###*
# The kilograms of the identity
# @property {String} kilograms
###
###*
# The centimeters of the identity
# @property {String} centimeters
###
###*
# The lat of the identity
# @property {Double} lat
###
###*
# The lng of the identity
# @property {Double} lng
###



module.exports = Identity