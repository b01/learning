## Logs

## Logs on Ubuntu 26.04

To clear and reset logs on Ubuntu `26.04`, you must use systemd utilities rather
than deleting the files directly, which can break logging services. Use
`journalctl` to clear system logs by time or size, and safely truncate
individual files in without interrupting running services. [1, 2, 3, 4]

### Systemd Journal Logs

#### Reset

Ubuntu uses  to manage system logs. You can safely reset them by vacuuming.

* Delete logs older than a specific duration (e.g., 7 days):

  ```shell
  sudo journalctl --vacuum-time=7d
  ```
* Limit the total journal size (e.g., to 500 MB):
  ```shell
  sudo journalctl --vacuum-size=500M
  ```
* To rotate and immediately reset your logs to start fresh: [1, 6, 7]

  ```shell
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=1s
  ```

#### View

* All kubelet logs: `journalctl -u kubelet`
* Follow live logs (tail -f): `journalctl -u kubelet -f`
* View the last 100 lines: `journalctl -u kubelet -n 100`

### Reset Individual Application Logs

For traditional text-based logs stored in  (such as `syslog`, `auth.log`, or
application-specific logs), you should truncate them to zero bytes. Never
delete the files entirely, as running daemons may fail to write to missing
files.

* Reset a specific log file to zero:

  ```shell
  sudo truncate -s 0 /var/log/syslog
  ```
* Reset all text logs in  safely:

  ```shell
  for f in /var/log/*.log; do sudo truncate -s 0 "$f"; done
  ```
* If a service stops writing after it's truncated, restart the logger: [2, 3, 8]

  ```shell
  sudo systemctl restart rsyslog
  ```

## Clear Terminal Command History (Optional)

If you also meant clearing your user's terminal/shell logs:

* To clear the current session and write the history file: [1, 9]

  ```shell
  history -c && history -w
  ```

If you tell me what specific logs or applications you are trying to clear, I can provide the exact service restart commands to prevent any logging downtime.
AI responses may include mistakes.

[1]: https://khatzie.medium.com/free-up-space-how-to-clear-logs-on-ubuntu-server-f71ea800449c
[2]: https://oneuptime.com/blog/post/2026-03-02-how-to-clean-up-old-logs-to-free-disk-space-on-ubuntu/view
[3]: https://serverfault.com/questions/285843/is-there-a-proper-way-to-clear-logs
[4]: https://askubuntu.com/questions/277711/how-do-i-clear-out-log-files-and-such
[5]: https://www.youtube.com/watch?v=AXfboZnKtgg
[6]: https://www.linkedin.com/pulse/how-clear-logs-free-up-disk-space-ubuntu-abhishek-kumar-frh1f
[7]: https://gist.github.com/bearlike/5d9fa646d1171fa996f09e82ccfc6eb0
[8]: https://unix.stackexchange.com/questions/27649/cleaning-log-files-under-linux
[9]: https://www.cyberciti.biz/faq/clear-the-shell-history-in-ubuntu-linux/

