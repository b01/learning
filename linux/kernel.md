# Kernel

## Parameters

* `net.ipv4.ip_forward` - This parameter determines if a system should allow
  forwarding of IP network packets. This functionality is required for systems
  that act as a gateway or router.

  IP forwarding in the Linux kernel allows a host to route network traffic from
  one interface to another. By default, this feature is disabled for security
  reasons, meaning the kernel drops any packet that is not explicitly addressed
  to the local machine. Enabling it transforms your Linux machine into a
  layer 3 router, which is essential for NAT gateways, VPN servers, and
  container orchestration platforms like Docker.

## Sysctl

The sysctl tool allows configuring kernel parameters or tunables.

### Files and locations

The configuration of sysctl is typically spread over multiple files and paths.
Systems with systemd will have additional paths.

Files are read in order and the first match of a kernel setting is used.

1. /etc/sysctl.d/*.conf
2. /run/sysctl.d/*.conf
3. /usr/local/lib/sysctl.d/*.conf
4. /usr/lib/sysctl.d/*.conf
5. /lib/sysctl.d/*.conf
6. /etc/sysctl.conf

## Options

* `sysctl -a` - To display all available kernel settings.



Site at [Sysctl]

---

[Sysctl]: https://linux-audit.com/kernel/sysctl/
