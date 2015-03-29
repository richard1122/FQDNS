fs = require 'fs'

exports.getID = (msg) ->
    return msg.readUIntBE 0, 2
exports.parseConfig = ((key)->
    configJSON = null

    return (() ->
        this.configJSON = JSON.parse(fs.readFileSync('./config.json').toString()) if not configJSON?
        return this.configJSON[key]
    )()
)
