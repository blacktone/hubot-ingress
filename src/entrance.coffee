# Description:
#   Entrance notifications
#
# Dependencies:

# Configuration:
#
# Commands:

# Author:
#   logikz

welcomeMessage = '''
Welcome to Slack! :allthethings:
Please enjoy the use of our ingress bot - Tardis.  You can type ```tardis help``` for command usage.  
Please only use tardis in random or in private message directly to Tardis.  He can be quite the talker :). 
Feel free to make public and private chat rooms to discuss various topics.  

If you need any help, feel free to message The82ndDoctor
'''

module.exports = (robot) ->
	robot.enter (msg)->
		room = msg.message.room
		if(room == "general" or room == "random")
			msg.reply(welcomeMessage)
