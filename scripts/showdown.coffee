module.exports = (robot) ->
  robot.respond /showdown/i , (msg) ->
    msg.http('https://api.nudgeyourself.com/showdown')
       .get() (err, res, body) ->
          data = JSON.parse(body)
          for key, company of data["companies"]
            msg.send "#{company['name']}: #{company['steps']}"

