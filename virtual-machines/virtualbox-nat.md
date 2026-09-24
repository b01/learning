# VirtualBox NAT Network

Vagrant assumes there is an available NAT device on eth0. NAT adapters currently
do not support port forwarding over IPv6. Because of this, it is not possible to
use vagrant ssh with IPv6 only VMs. Setting up a second NIC is the current
work-a-round.

Vagrant with VirtualBox clones each machine it spins up from the VM image. This
also means the machines will have the same MAC addresses and IPs on the first
NIC. We do not want that. So we will use the Vagrantfile to set a mac
address for each machine. from there the DHCP server should give each machine
a different IP. This should resolve network issues when these machines talk
to each other or if you time them into the same network.

We will attach the 2nd adapter to a "Nat Network", which we also be done in the
Vagrantfile, we can then try to use `--port-foraward-6`.

NOTE: You currently cannot configure port forwarding through the VirtualBox GUI
at the time of writing this. It MUST be done through the command line.


## How To Give Each Machine A Unique MAC Address

You can change a VMs mac address with the following:

```shell
vboxmanage modifyvm <vm-id> --macaddress1 auto
```

```ruby
# In a Vagrantfile
vb.customize ["modifyvm", :id, "--macaddress1", "auto"]
```

NOTE: Doing this will cause you to see an error when the machine boots up.
That is because there is a `netplan` that matches on the old mac address. We
will update it so that future boots do not throw an error/warning.
