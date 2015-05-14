log = require('log4js').getLogger("GeoTool")

class GeoTool

  # Returns a position in radians instead of degrees
  ToRadians = (pos) ->

    radLat = (Math.PI/180) * pos.lat
    radLng = (Math.PI/180) * pos.lng
    return {lat: radLat, lng: radLng}

  # Calculates the distance between the two points
  @getDistance: (pos1, pos2) ->

    r = 6371.0  #KM
    
    lat1 = ToRadians(pos1).lat
    lat2 = ToRadians(pos2).lat
    d1 = (ToRadians(pos2).lat - ToRadians(pos1).lat)
    d2 = (ToRadians(pos2).lng - ToRadians(pos1).lng)

    a = Math.sin(d1 / 2.0) * Math.sin(d1 / 2.0) +
    Math.cos(lat1) * Math.cos(lat2) *
    Math.sin(d2 / 2.0) * Math.sin(d2 / 2.0);
    c = 2.0 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0 - a));
    d = r * c;

    return d;

  ###*
  # Evaluate the closest element from a list given a element
  # @method getClosest
  # @param {Object} element
  # @param {Object[]} places
  # @param {Object[]] blacklist
  # @static
  ###
  @getClosest: (element, places, blacklist = []) ->

    closestDist = Number.MAX_VALUE
    closest = null

    for place in places

      if place in blacklist
        continue

      dist = GeoTool.getDistance(place, element)

      if dist < closestDist
        closest = place
        closestDist = dist
    return closest

  # Returns the time it takes for light to travel between the two points in milliseconds
  @getLatency: (pos1, pos2)->
    distance = GeoTool.getDistance(pos1, pos2)
    speed = 299792.458
    milliseconds = (distance / speed) * 1000

    return milliseconds

module.exports = GeoTool

