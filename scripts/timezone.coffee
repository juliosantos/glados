# Description:
#   Submit time query to www.timeapi.org
#
# Commands:
#   hubot time - Current time in local timezone
#   hubot time <timezone> - Current time in timezone
#   hubot time <timezone> <query> - Time in timezone based on query

module.exports = (robot) ->

  robot.respond /time (\D{3})([\d\D ]*)/i, (msg) ->
    tz = msg.match[1] || "utc"
    q = msg.match[2].trim() || "now"
    url = "http://www.timeapi.org/" + tz + "/" + q
    msg.http(url)
      .get() (err, res, body) ->
        if res.statusCode == 500
          msg.send "Sorry, I don't understand that time query. See http://chronic.rubyforge.org"
        else
          msg.send body
