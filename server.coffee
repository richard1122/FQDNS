dgram = require 'dgram'
config = require './common'
crypto = require 'crypto'

idLen = config.idLen
dnsServer = "10.10.0.21"

init = () ->
    s = dgram.createSocket 'udp4'
    s.bind 12345
    s.on 'message', (msg, rinfo)->
        console.log rinfo
        if (rinfo.address != dnsServer) 
            s.send msg, 0, msg.length, 53, dnsServer
        else
            s.send msg, 0, msg.length, 8053, "127.0.0.1"

init()