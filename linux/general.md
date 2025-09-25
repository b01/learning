# General

Notes for in general everyday shelling.

Be sure to also check out [Bash Features] for all your Bashy needs!


## passwd

-S, --status
Display account status information. The status information
consists of 7 fields. The first field is the user's login
name. The second field indicates if the user account has a
locked password (L), has no password (NP), or has a usable
password (P). The third field gives the date of the last
password change. The next four fields are the minimum age,
maximum age, warning period, and inactivity period for the
password. These ages are expressed in days.

## Split String into Variables

```shell
read IP4 IP6 <<< "$(hostname -I)"
echo ${IP4}
echo ${IP6}
```

The `<<<` redirects the content of the output to read's standard input.

## Resources

---

[Bash Features]: https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html