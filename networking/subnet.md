# Subnet

## IPv6

The address `fd12:3456:789a:1000::/56` block is an IPv6 network prefix. Because
it starts with `fd`, it belongs to the Unique Local Address (ULA) range, which
is reserved for private networks and is not routable on the public internet. [1]

### Network Breakdown

* Address Space: `fd12:3456:789a:1000::` to
  `fd12:3456:789a:10ff:ffff:ffff:ffff:ffff`
* Total Host IP Addresses: 4.72 × 10²¹ addresses (2⁷² total allocations)
* Prefix Length:  (The first 56 bits represent the fixed routing network prefix,
  leaving 72 bits for subnetting and host addressing).

### Subnet Allocation

In standard IPv6 architecture, individual Local Area Networks (LANs) are
assigned a  prefix length to ensure optimal compatibility with automated
assignment features like SLAAC (Stateless Address Autoconfiguration). [2, 3]

A `/56` network allocation provides exactly 256 individual `/64` subnets. This
makes it an ideal block size for a medium-sized company office or a advanced
home network with separate VLANs. [4]

The available  subnets in your block range from:

* First Subnet: `fd12:3456:789a:1000::/64`
* Second Subnet: `fd12:3456:789a:1001::/64`
* Third Subnet: `fd12:3456:789a:1002::/64`
* ... continuing through hexadecimal increments ...
* Last Subnet: `fd12:3456:789a:10ff::/64`

[1]: https://en.wikipedia.org/wiki/Unique_local_address
[2]: https://www.reddit.com/r/ipv6/comments/7b7t7s/are_people_using_unique_local_addresses_for_their/
[3]: https://subnettingpractice.com/ipv6-subnet-calculator.html
[4]: https://github.com/moby/moby/issues/45296
