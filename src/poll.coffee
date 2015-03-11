# Description:
#   Handle polls
#
# Dependencies:
#   Moment-timezone.js
#
# Configuration:
#
# Commands:
#   hubot start poll [topic] {option:[option]}
#   hubot stop poll [pollId]
#   hubot vote [pollId] [#option]
# Author:
#   logikz   

module.exports = (robot) ->
	generateId = ->
		text = ""
		possibleValues = "0123456789abcdef"
		text += possibleValues.charAt(Math.floor(Math.random() * possibleValues.length)) for [1..5]    

	parseOptions = (optionsString) ->
		(optionsString.split "option: ")[1..]

	createPoll = (topic, options) ->
		@robot.logger.info "Creating poll with #{topic}"
		id = generateId()
		pollOptions = parseOptions options
		@robot.logger.info "We have #{pollOptions.length()} options"
		@robot.brain.data.poll[id].topic = topic
		optionsString = ""

		for pollOption in pollOptions
			index = pollOptions.indexOf(pollOption)
			robot.brain.data.poll[id].option[index].text
			optionsString += "\t#{index}: #{pollOption}\n"
		@robot.brain.save()
		@robot.logger.info "Brain saved"

		text =  """
				POLL ID: #{id}
				Topic: #{topic}
				Options:
				#{optionsString}
				"""

	robot.respond /start poll (.*?)\s(option:\s?.*)+/i, (msg) ->
		@robot.logger.info "Create poll called: #{msg}"
		topic = msg.match[1]
		@robot.logger.info "Topic: #{topic}"
		options = msg.match[2]
		@robot.logger.info "options: #{options}"
		@robot.logger.info @
		response = @createPoll topic, options
		msg.send "@channel: #{response}"

	robot.respond /poll ping/i, (msg) ->
		@robot.logger.info "ping called"
		msg.reply "poll pong"


