# Description:
#   Entrance notifications
#
# Dependencies:

# Configuration:
#
# Commands:

# Author:
#   logikz

module.exports = (robot) ->
	robot.enter (msg)->
		room = msg.message.room
		if(room == "trello")
			msg.reply("test")


