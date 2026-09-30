# Default Gateway

A default gateway is the device that connects a local network to external
networks.

If your computer wants to reach a device that is not part of its immediate
network, and there is no other route, then traffic is directed to the default
gateway.

## Process

When a device wants to communicate with another device outside its subnet, it
forwards the request to the gateway, which then routes it appropriately. Here’s
a high-level overview of the process:

1. Your device checks the destination, if the destination is outside the subnet,
   the device sends the data to the default gateway.
2. Gateway receives the packet, using its routing table, then determines the
   best path to forward it to the destination device.
3. Replies from the destination device travel back through the gateway to your
   device.

## Common Default Gateway Addresses

**IPv4**
Some of the most common IPv4 gateway addresses include:

* `192.168.0.1` – Often used by Netgear and D-Link routers.
* `192.168.1.1` – Common for Linksys, Cisco, and many ISP-provided routers.
* `192.168.100.1` – Frequently used in cable modem setups.
* `10.0.0.1` – Sometimes used by enterprise networks and certain ISPs (e.g.,
  Comcast/Xfinity).

These addresses belong to private IP ranges defined by the Internet Assigned
Numbers Authority (IANA):

* `10.0.0.0` – 10.255.255.255
* `172.16.0.0` – 172.31.255.255
* `192.168.0.0` – 192.168.255.255

**IPv6**

With IPv6, gateways are often assigned automatically by the router using
link-local addresses (starting with `fe80::`). Instead of typing them manually,
devices typically obtain the IPv6 default gateway via Neighbor Discovery
Protocol (NDP).

## Why It Is Important

Without it, your local network would be isolated from the outside world.

Reasons it matters:

* Internet access - this is the same as communication between networks, but we
  love the internet so much it often gets its own mention.
* Communication between Networks
* Centralized Traffic Control
* Security Enforcement
* Network Services Integration - Gateways often handle additional services like
  DHCP (assigning IP addresses), NAT (network address translation), and VPN
  routing.

## Security Considerations

**Change Default Passwords**

If you have a device that serves as a router/gateway, they often come with
default usernames and passwords, which are widely known and easy to exploit.
Always set a strong, unique password to prevent unauthorized access.

**Keep Firmware Updated**

Gateway device manufacturers regularly release firmware updates to patch
vulnerabilities with the latest security protections.

**Disable Remote Access**

Unless necessary, turn off remote management features that allow access to the
gateway from outside your local network.

**Use Firewalls**

Use firewalls to filter unwanted traffic and block suspicious connections
before they reach your network.

**Monitor Network Activity**

Regularly check logs and network activity to detect unusual behavior. Early
detection can help prevent breaches or mitigate damage.

**Segment Your Network**

In larger networks, using VLANs or separate subnets with controlled gateway
access can reduce the risk of lateral movement if one segment is compromised.

## How Dual NIC Routing Works

A single default gateway will handle all non-local outbound traffic for multiple
network interface cards (NICs) on a system.

**Local Traffic**

When your computer sends data to a device on the exact same local subnet as one
of the NICs, it sends the data directly through that specific NIC without using
the default gateway.

**Non-Local Traffic**

When your computer sends data to an outside network or the internet, it checks
the routing table. Because only one NIC has a default gateway defined, all
internet and external traffic will funnel through that specific NIC and its
assigned gateway. The second NIC will sit idle for any outbound traffic that is
not on its specific local subnet.

### Best Practices

**Single Gateway Rule**: Having one default gateway across multiple NICs is the
correct and standard way to avoid unpredictable routing loops or conflict
issues.

**Static Routes**: If you need the second NIC to talk to specific external
subnets, do not add a second default gateway. Instead, configure specific
static routes pointing to that second NIC.