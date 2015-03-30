dgram = require 'dgram'
common = require './common'
crypto = require 'crypto'

FQServer = common.parseConfig 'server_addr'
FQServerPort = parseInt(common.parseConfig 'server_port')

console.log FQServer, FQServerPort

idAddrQueue = []
idAddrQueuePointer = 0
ID_ADDR_QUEUE_SIZE = 200

enQueue = (id, rinfo) ->
    idAddrQueuePointer = (idAddrQueuePointer + 1) % ID_ADDR_QUEUE_SIZE
    idAddrQueue[idAddrQueuePointer] = 
        id: id
        rinfo: rinfo

findQueue = (id) ->
    for i in [0...ID_ADDR_QUEUE_SIZE]
        r = idAddrQueue[i]
        return r.rinfo if r? and r.id is id
    return null

listenSocket = dgram.createSocket 'udp4'
listenSocket.bind 8053
listenSocket.on 'message', (msg, rinfo) ->
    console.log rinfo, msg
    if (rinfo.address == FQServer and rinfo.port == FQServerPort)
        # server response
        rinfo = findQueue common.getID(msg)
        if (rinfo?)
            listenSocket.send msg, 0, msg.length, rinfo.port, rinfo.address
        else
            console.log 'Warning: DNS request response match failed'
    else
        # client query
        id = common.getID msg
        enQueue id, rinfo
        msg = common.encrypt msg
        listenSocket.send msg, 0, msg.length, FQServerPort, FQServer

