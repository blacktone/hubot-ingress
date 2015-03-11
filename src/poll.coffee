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

generateId = () ->
    text = ""
    possibleValues = "0123456789abcdef"
    text += possibleValues.charAt(Math.floor(Math.random() * possibleValues.length)) for [1..5]
    return text

parseOptions = (optionsString) ->
    return (optionsString.split "option: ")[1..]

createPoll = (robot, topic, options...) ->
    @robot.logger.info "Creating poll with #{topic}"
    id = generateId
    pollOptions = parseOptions options
    @robot.logger.info "We have #{pollOptions.length()} options"
    robot.brain.data.poll[id].topic = topic
    optionsString = ""

    for pollOption in pollOptions
        index = pollOptions.indexOf(pollOption)
        robot.brain.data.poll[id].option[index].text
        optionsString += "\t#{index}: #{pollOption}\n"
    robot.brain.save()
    @robot.logger.info "Brain saved"

    text =  """
            POLL ID: #{id}
            Topic: #{topic}
            Options:
            #{optionsString}
            """
    return text
    

module.exports = (robot) ->
    robot.respond /start poll (.*?)\s(option:\s?.*)+/i, (msg) ->
        @robot.logger.info "Create poll called"
        topic = msg.match[1]
        options = msg.match[2]
        response = createPoll robot, topic, options
        msg.send "@channel: #{response}"

    robot.respond /poll ping/i, (msg) ->
        @robot.logger.info "ping called"
        msg.reply "poll pong"


