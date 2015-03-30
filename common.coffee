fs = require 'fs'
crypto = require 'crypto'

exports.getID = (msg) ->
    return msg.readUIntBE 0, 2
exports.parseConfig = ((key)->
    configJSON = null
    return (() ->
        @configJSON = JSON.parse(fs.readFileSync('./config.json').toString()) if not @configJSON?
        return @configJSON[key]
    )()
)
exports.encrypt = (msg) ->
    cipher = crypto.createCipher 'aes-256-cbc', getPWD()
    return Buffer.concat [cipher.update(msg), cipher.final()]

exports.decrypt = (msg) ->
    decipher = crypto.createDecipher 'aes-256-cbc', getPWD()
    return Buffer.concat [decipher.update(msg), decipher.final()]

getPWD = (() ->
    password = null
    return (() ->
        if not @password?
            pwd = exports.parseConfig 'key_pwd'
            salt = exports.parseConfig 'key_salt'
            iter = parseInt(exports.parseConfig 'key_iter')
            len = parseInt(exports.parseConfig 'key_len')
            @password = crypto.pbkdf2Sync(pwd, salt, iter, len).toString('hex')
        return @password
    )()
)