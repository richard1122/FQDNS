dgram = require 'dgram'
common = require './common'
crypto = require 'crypto'

dnsServer = common.parseConfig 'dns_server_addr'
dnsServerPort = parseInt(common.parseConfig 'dns_server_port')
serverPort = parseInt(common.parseConfig 'server_port')

queue = new common.queue()

s = dgram.createSocket 'udp4'
s.bind serverPort
s.on 'message', (msg, rinfo)->
    console.log rinfo
    if rinfo.address isnt dnsServer
        msg = common.decrypt msg
        queue.enqueue
            id: common.getID msg
            rinfo: rinfo
        s.send msg, 0, msg.length, dnsServerPort, dnsServer
    else
        rinfo = queue.find common.getID(msg), (r1, dft) ->
            return r1.id is dft
        if (rinfo?)
            msg = common.encrypt msg
            s.send msg, 0, msg.length, rinfo.rinfo.port, rinfo.rinfo.address
        else
            console.log 'Warning: DNS request response match failed'
