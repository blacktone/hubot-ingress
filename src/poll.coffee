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
class Option
	constructor: () ->
class Poll
	constructor: (@id) ->

module.exports = (robot) ->
	robot.respond /start poll (.*?)\s(option:\s?.*)+/i, (msg) ->
		try
			@robot.logger.info "Create poll called: #{msg}"
			topic = msg.match[1]
			@robot.logger.info "Topic: #{topic}"
			options = msg.match[2]
			@robot.logger.info "options: #{options}"
			# @robot.logger.info createPoll
			# response = createPoll topic, options
			@robot.logger.info "Creating poll with #{topic}"
			id = ""
			possibleValues = "0123456789abcdef"
			id += possibleValues.charAt(Math.floor(Math.random() * possibleValues.length)) for [1..5]
			@robot.logger.info "Poll ID: #{id}"

			pollOptions = (options.split "option: ")[1..]			
			@robot.brain.data.poll = {}
			@robot.brain.data.poll[id] = new Poll(id)
			@robot.logger.info "Poll init complete"
			@robot.brain.data.poll[id].topic = topic
			@robot.logger.info "Poll added topic"
			optionsString = ""

			@robot.brain.data.poll[id].options = {}
			for pollOption in pollOptions
				index = pollOptions.indexOf(pollOption)
				@robot.brain.data.poll[id].options[index] = new Option()
				@robot.brain.data.poll[id].options[index].text = pollOption
				optionsString += "\t#{index}: #{pollOption}\n"
			@robot.brain.save()
			@robot.logger.info "Brain saved"

			text =  """
					POLL ID: #{id}
					Topic: #{topic}
					Options:
					#{optionsString}
					"""
			msg.send "@channel: #{text}"
		catch error
			msg.send error
			@robot.logger.info error

	robot.respond /vote\s+([a-f\d]{5})\s+(\d)/i, (ms) ->
		msg.reply "Thanks for your vote"
		
	robot.respond /poll ping/i, (msg) ->
		@robot.logger.info "ping called"
		msg.reply "poll pong"


