# FQDNS
A dns server, encrypt dns queries to remote server.

Features:

* encrypt dns request to remote server
* prevent GFW DNS poisoning, http://en.wikipedia.org/wiki/DNS_spoofing
* udp package for quick query

Todo:

* more secure
* IPV6 support(now support query AAAA, but only ipv4 server address available)
* local bind address configurable(now listen on all interface)
* chnroute for china website to speed up (or for cdn)
* auto retry and cache?


# license

MIT http://opensource.org/licenses/MIT