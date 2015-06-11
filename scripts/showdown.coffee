module.exports = (robot) ->
  robot.respond /showdown/i , (msg) ->
    msg.http('https://api.nudgeyourself.com/showdown')
       .get() (err, res, body) ->
          data = JSON.parse(body)
          showWarning = true

          for key, company of data["companies"]
            if key == 0 && company['name'] == "Mobility Labs"
              showWarning = false

            msg.send "#{company['name']}: #{company['steps']}"

          msg.send "You guys are slacking! How is #{data['companies'][0]['name']} beating you?" if showWarning
          msg.send "You guys are slacking!" unless showWarning

