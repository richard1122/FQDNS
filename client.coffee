dgram = require 'dgram'
common = require './common'
crypto = require 'crypto'

FQServer = common.parseConfig 'server_addr'
FQServerPort = parseInt(common.parseConfig 'server_port')

queue = new common.queue()

listenSocket = dgram.createSocket 'udp4'
listenSocket.bind 8053
listenSocket.on 'message', (msg, rinfo) ->
    console.log rinfo
    if rinfo.address is FQServer and rinfo.port is FQServerPort
        # server response
        msg = common.decrypt msg
        rinfo = queue.find common.getID(msg), (r1, dft) ->
            return r1.id is dft
        if (rinfo?)
            listenSocket.send msg, 0, msg.length, rinfo.rinfo.port, rinfo.rinfo.address
        else
            console.log 'Warning: DNS request response match failed'
    else
        # client query
        queue.enqueue 
            id: common.getID msg
            rinfo: rinfo
        msg = common.encrypt msg
        listenSocket.send msg, 0, msg.length, FQServerPort, FQServer

