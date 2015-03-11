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
    id = generateId
    pollOptions = parseOptions options
    robot.brain.data.poll[id].topic = topic
    optionsString = ""

    for pollOption in pollOptions
        index = pollOptions.indexOf(pollOption)
        robot.brain.data.poll[id].option[index].text
        optionsString += "\t#{index}: #{pollOption}\n"
    robot.brain.save()

    text =  """
            POLL ID: #{id}
            Topic: #{topic}
            Options:
            #{optionsString}
            """
    

module.exports = (robot) ->
    robot.respond /start poll (.*?)\s(option:\s?.*)+/i, (msg) ->
        topic = msg.match[1]
        options = msg.match[2]
        response = createPoll robot, topic, options
        msg.send "@channel: #{response}"

    robot.respond /poll ping/i, (msg) ->
        msg.reply "poll pong"


