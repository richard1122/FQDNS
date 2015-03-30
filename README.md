# FQDNS
A dns server, to encrypt dns queries to remote server.

features:

* encrypt dns request to remote server
* prevent GFW DNS poisoning
* udp package for quick query

todo:

* IPV6 support(now support query AAAA, but only ipv4 server address available)
* local bind address configurable(now listen on all interface)
* chnroute for china website to speed up (or for cdn)