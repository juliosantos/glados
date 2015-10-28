_ = require( "lodash" );

var token = process.env.FAKE_USER_TOKEN;

module.exports = function (robot) {
  robot.hear( /glados group (\w*) (.*)/, function (res) {
    var userName = "@" + res.message.user.name;
    var groupName = res.match[1]
    var peopleToInvite = _.map( res.match[2].split( " " ).concat( userName ), function (atName) {
      return atName.slice( 1 )
    });
    
    // try to create channel
    var url = "https://slack.com/api/groups.create?token=" + token + "&name=" + groupName;
    robot.http( url ).get()( function (__, __, body) {
      body = JSON.parse( body );
      if (body.ok !== false) {
        var group = body.group;

        // get user list
        url = "https://slack.com/api/users.list?token=" + token;
        robot.http( url ).get()( function (__, __, body) {
          var users = JSON.parse( body ).members;
          // invite users
          _.each( peopleToInvite, function (person) {
            // find user in members
            var user = _.findWhere( users, {name : person} );
            // invite user
            url = "https://slack.com/api/groups.invite?token=" + token + "&channel=" + group.id + "&user=" + user.id;
            robot.http( url ).get()( function (__, __, body) {
              console.log( "invite", person, body );
            });
          });
          res.send( "Created a group for: " + peopleToInvite.join( ", " ) );
        });

        // leave channel
        setTimeout( function () {
          url = "https://slack.com/api/groups.leave?token=" + token + "&channel=" + group.id;
          robot.http( url ).get()( function (__, __, body) {
            console.log( "leave", body );
          });
        }, 5000 );
      } else {
        res.send( "Sorry bro: " + body.error );
      }
    });
  });
}
