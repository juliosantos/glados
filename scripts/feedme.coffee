# Description:
# Let's get some food truck data
#
# Commands:
#   hubot feed me
#   hubot cookie me

_ = require "lodash"

Number.prototype.toRad = ->
  this * Math.PI / 180

module.exports = (robot) ->
  getCurrentDistance = (lat, long, pointLat, pointLong) ->
    currLat = parseFloat(lat)
    currLon = parseFloat(long)

    if !pointLat or !pointLong
      # this is the coordinates to Gallery Place Chinatown in Washington DC
      pointLat = 38.897968;
      pointLong = -77.021934;

    R = 6371;                   #Radius of the earth in Km
    dLat = (pointLat - currLat).toRad();    #delta (difference between) latitude in radians
    dLon = (pointLong - currLon).toRad();    #delta (difference between) longitude in radians

    currLat = currLat.toRad();          #conversion to radians
    pointLat = pointLat.toRad();

    a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(currLat) * Math.cos(pointLat);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));   #must use atan2 as simple arctan cannot differentiate 1/1 and -1/-1
    distance = Math.abs(R * c);   #sets the distance
    distance = Math.round(distance*10)/10;      #rounds number to closest 0.1 km
    return distance;    #returns the distance

  robot.respond /cookie me/i, (msg) ->
    random = Math.floor(Math.random()*10000000000)
    robot.http("http://foodtruckfiesta.com/apps/map_json.php?")
      .query({
        num_days: 365
        minimal: 0
        alert_nc: "y"
        alert_hc: 0
        alert_pm: 0
        rand: random
      })
      .get() (err, res, body) ->
        locations = JSON.parse(body)

        message_to_send = ''

        unless locations.markers?
          msg.send "No captain cookie on the map :disapproval_look:"
          return
        captain_cookie_truck = null;

        for marker in locations.markers
          distance = getCurrentDistance(marker.coord_lat, marker.coord_long)
          if String(marker.truck).toLowerCase() == 'captaincookiedc'
            marker.distance = distance

            if captain_cookie_truck
              if captain_cookie_truck.distance > distance
                captain_cookie_truck = marker
            else
              captain_cookie_truck = marker

        if captain_cookie_truck?
          if captain_cookie_truck.distance < 0.5
            message_to_send = "YES, CAPTAIN COOKIE IS IN GALLERY PLACE!"
          else if captain_cookie_truck.distance >= 0.5 and captain_cookie_truck.distance < 1.0
            message_to_send = "It's a little walk, but they claim to be in Metro Center"
          else
            message_to_send = "That dirty lying truck is no where near Gallery Place :disapproval_look:"
        else
          message_to_send = "That dirty lying truck is no where near Gallery Place :disapproval_look:"

        msg.send message_to_send

  showNearbyTrucks = (msg, markers, address, pointLat, pointLong) ->
    message_to_send = ''
    metro_message=''
    nearby = []
    metro_place_trucks = []

    if !address
      address = "Gallery Place"
      nearby_distance = 0.5
    else
      # search a bit wider if using custom address
      nearby_distance = 1.0

    for marker in markers
      marker.distance = getCurrentDistance(marker.coord_lat, marker.coord_long, pointLat, pointLong)
      if marker.distance < nearby_distance
        nearby.push(marker)
      else if marker.distance == nearby_distance
        metro_place_trucks.push(marker)

    if nearby.length > 0
      message_to_send = "Trucks near #{address}: \n"
      for truck in nearby
        message_to_send = message_to_send + "#{truck.print_name} http://www.twitter.com/#{truck.truck}, #{truck.distance} km away \n"
    else
      message_to_send = "Oh no, there's nothing near #{address}!\n"

    # This stuff is only relevant if we're searching from Gallery Place
    if address == "Gallery Place"
      if metro_place_trucks.length > 0
        message_to_send = message_to_send + "\nTrucks at Metro Center: \n"
        if(_.findWhere(metro_place_trucks, {print_name: 'Captain Cookie'}))
          metro_message = "Captain Cookie http://www.twitter.com/captaincookiedc \n" + metro_message
          if((metro_place_trucks.length-1)>0)
            metro_message = metro_message + "And #{metro_place_trucks.length-1} Other Trucks\n"
        else
          metro_message = metro_message + "There are #{metro_place_trucks.length} Trucks In A Galaxy Far Far Away..\n"
      else
        message_to_send = message_to_send + "\nAnd nothing at Metro Center!\n"

    message_to_send= message_to_send+metro_message
    msg.send message_to_send

  robot.respond /feed me(.*)/i, (msg) ->
    random = Math.floor(Math.random()*10000000000)
    robot.http("http://foodtruckfiesta.com/apps/map_json.php?")
      .query({
        num_days: 365
        minimal: 0
        alert_nc: "y"
        alert_hc: 0
        alert_pm: 0
        rand: random
      })
      .get() (err, res, body) ->
        locations = JSON.parse(body)

        unless locations.markers?
          msg.send "No trucks on the map :disapproval_look:"
          return

        query = msg.match[1].trim()

        if query
          # shamelessly ripped off from: http://bit.ly/1xzaecc
          robot.http("https://maps.googleapis.com/maps/api/geocode/json")
            .header('User-Agent', 'Hubot Geocode Location Engine')
            .query({
              address: query,
              sensor: false
            })
            .get() (err, res, body) ->
              response = JSON.parse(body)
              if response.results.length == 0
                msg.send "Oh no, I couldn't find \"#{query}\". I have failed. :disappointed:"
                return

              result = response.results[0]
              msg.send "Searching for food near: #{result.formatted_address}"
              pointLat = result.geometry.location.lat
              pointLong = result.geometry.location.lng
              showNearbyTrucks(msg, locations.markers, result.formatted_address, pointLat, pointLong)
        else
          showNearbyTrucks(msg, locations.markers)