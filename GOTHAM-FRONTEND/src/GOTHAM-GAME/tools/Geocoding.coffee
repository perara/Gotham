CRG = require ('../dependencies/country_reverse_geocoding.js')


class Geocoding

  @getCountry: (lat, lng) ->
    return CRG.country_reverse_geocoding().get_country(lat,lng);


  #http://www.movable-type.co.uk/scripts/latlong.html
  Geocoding.CalculateDistance = (coordinate1, coordinate2) ->
    R = 6371000; # metres

    g1 = coordinate1.lat * Math.PI / 180;
    g2 = coordinate2.lat * Math.PI / 180;
    h1 = (coordinate2.lat-coordinate1.lat)* Math.PI / 180;
    h2 = (coordinate2.lng-coordinate1.lng)* Math.PI / 180;

    a = Math.sin(h1/2) * Math.sin(h1/2) + Math.cos(g1) * Math.cos(g2) * Math.sin(h2/2) * Math.sin(h2/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c;






module.exports = Geocoding