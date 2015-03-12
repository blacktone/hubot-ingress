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
	constructor: () ->

module.exports = (robot) ->
	robot.respond /start poll (.*?)\s(option:\s?.*)+/i, (msg) ->
		try
			@robot.logger.info "Create poll called: #{msg}"
			topic = msg.match[1]
			#@robot.logger.info "Topic: #{topic}"
			options = msg.match[2]
			#@robot.logger.info "options: #{options}"			
			@robot.logger.info "Creating poll with #{topic}"			
			
			pollOptions = (options.split "option: ")[1..]			
			@robot.brain.data.poll = new Poll()
			@robot.logger.info "Poll init complete"
			@robot.brain.data.poll.topic = topic
			@robot.logger.info "Poll added topic"
			optionsString = ""

			@robot.brain.data.poll.options = {}
			for pollOption in pollOptions
				index = pollOptions.indexOf(pollOption)
				@robot.brain.data.poll.options[index] = new Option()
				@robot.brain.data.poll.options[index].text = pollOption
				optionsString += "\t#{index}: #{pollOption}\n"
			@robot.brain.save()
			@robot.logger.info "Brain saved"

			text =  """					
					Topic: #{topic}
					Options:
					#{optionsString}
					"""
			msg.send "@channel: #{text}"
		catch error
			msg.send error
			@robot.logger.info error

	robot.respond /vote\s+(\d)/i, (msg) ->		
		vote = msg.match[1]
		user = msg.envelope.user['name']
		@robot.logger.info "Adding a vote for #{vote} for #{user}"
		#check if the user already voted
		for option in @robot.brain.data.poll.options
			@robot.logger.info "Checking #{option}"
			if option.users != undefined
				@robot.logger.info "Some have voted for this one"
				option.users = option.users.filter (currentUser) -> currentUser isnt user
		if @robot.brain.data.poll.options[vote].users.length > 0
			@robot.logger.info "add user to this option since it's defined"
			@robot.brain.data.poll.options[vote].users.push(user)
		else
			@robot.logger.info "First vote, create new array"
			@robot.brain.data.poll.options[vote].users = []
			@robot.brain.data.poll.options[vote].users.push(user)
		@robot.brain.save()
		@robot.logger.info "Brain saved"
		msg.reply "Thanks for your vote"

	robot.respond /view results/i, (msg) ->
		@robot.logger.info "View results"
		topic = @robot.brain.data.poll.topic		
		@robot.logger.info "#{@robot.brain.data.poll.options}"	
		options = @robot.brain.data.poll.options
		@robot.logger.info "#{options}"	
		optionString = ""
		for option in options
			index = options.indexOf(option)
			text = option.text
			numVotes = if option.users == undefined then 0 else option.users.length
			users = option.users
			@robot.logger.info "option: #{option} :: text: #{text} :: count: #{numVotes}"
			optionString += "\t#{index}: #{text} Total: #{numVotes} Users:(#{users.join(", ")})\n"
		msg.send """
		#{topic}
		Current Poll Results:
		#{optionString}
		"""

	robot.respond /poll ping/i, (msg) ->
		@robot.logger.info "ping called"
		msg.reply "poll pong"


