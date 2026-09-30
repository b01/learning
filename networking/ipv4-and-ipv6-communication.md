# IPv4 and IPv6 Communication

It is possible with a service sitting in between.

`64:ff9b::/96` is the well-known IPv6 prefix standardized for NAT64 and DNS64
translation, which allows IPv6-only clients to communicate with IPv4-only
servers.

## How It Works

* Embedding IPv4: The last 32 bits of this /96 network prefix store the target
  IPv4 address.
* DNS Resolution: A DNS64 server intercepts an IPv4 lookup request (A record)
  and synthesizes an IPv6 address (AAAA record) by combining `64:ff9b::/96`
  with the resolved IPv4 address.
* Packet Translation: A NAT64 router receives the traffic sent to that prefix,
  strips the IPv6 header/prefix, translates the packet into an IPv4 packet,
  and forwards it to the IPv4 internet.
