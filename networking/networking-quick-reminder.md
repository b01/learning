# Networking Quick Reminder


### Routing Table

* Run `ip route` or `ip route show` to display the main routing table.
* Run `ip route show table all` to view entries across all routing tables.
* Run `ip route get <destination-ip>` to see which specific route and interface
  traffic will use for an address.

**Resources**

[list-all-route-tables], [find-interface-for-route-to-specific-host],
[view-routing-table-linux].

---

[list-all-route-tables]: https://serverfault.com/questions/618857/list-all-route-tables
[find-interface-for-route-to-specific-host]: https://serverfault.com/questions/531751/find-interface-for-route-to-specific-host
[view-routing-table-linux]: https://oneuptime.com/blog/post/2026-03-20-view-routing-table-linux/view
