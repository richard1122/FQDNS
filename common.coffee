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

exports.queue = class
    constructor: () ->
        @queue = []
        @pointer = 0
        @QUEUE_SIZE = 200
    enqueue : (val) ->
        @pointer = (@pointer + 1) % @QUEUE_SIZE
        @queue[@pointer] = val
    find : (val, cmp) ->
        for i in [0...@QUEUE_SIZE]
            return @queue[i] if @queue[i]? and cmp @queue[i], val
        return null

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