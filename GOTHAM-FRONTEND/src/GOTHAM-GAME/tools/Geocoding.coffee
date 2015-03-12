CRG = require ('../dependencies/country_reverse_geocoding.js')


class Geocoding

  @getCountry: (lat, lng) ->
    return CRG.country_reverse_geocoding().get_country(lat,lng);




module.exports = Geocoding