log = require('log4js').getLogger("GeoTool")

class GeoTool

  ToRadians = (pos) ->

    radLat = (Math.PI/180) * pos.lat
    radLng = (Math.PI/180) * pos.lng
    return {lat: radLat, lng: radLng}

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

  # Returns the closest place to "goal" from "nodeList"
  @getClosest: (goal, places, blacklistIds = []) ->

    closestDist = Number.MAX_VALUE
    closest = null

    for place in places

      if place.id in blacklistIds
        #log.info "#{place.id} in blacklist, ignoring"
        continue

      dist = GeoTool.getDistance(place, goal)

      if dist < closestDist
        closest = place
        closestDist = dist

    return closest

module.exports = GeoTool

