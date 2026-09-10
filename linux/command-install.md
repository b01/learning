# Command install

At some point in your Linux journey, you may stumble upon this command. It can
be useful over using the `cp` command to put files in place on the system.

## When to Use the `install` Command

* **Writing Automation Scripts**: Use it in shell scripts to deploy custom tools
  or configuration files across machines with precise security attributes.
* **Writing Makefiles**: Use it inside software development Makefiles under the
  make install target to compile source code and automatically place the
  binaries into system directories like `/usr/local/bin`.
* **Combining Steps**: Use it instead of chaining multiple individual commands
  (like mkdir, cp, chmod, and chown) to safely accomplish everything in one
  execution.
* **Safely Replacing Running Binaries**: Use it to replace an active system
  file or program. Unlike the cp command, which can crash an active application
  by modifying it in place, install unlinks the old file first to prevent
  corruption.


## When NOT to Use It

Do not use install if you are trying to download, manage, or update system
software packages. Use package managers instead.

## Quick Syntax Examples

| What you want to do                | The install command approach                  | The manual alternative (Chained commands)                              |
|------------------------------------|-----------------------------------------------|------------------------------------------------------------------------|
| Copy a script & make it executable | install -m 755 myscript.sh /usr/local/bin/    | cp myscript.sh /usr/local/bin/ && chmod 755 /usr/local/bin/myscript.sh |
| Create deep directories safely     | install -d /var/www/site/assets               | mkdir -p /var/www/site/assets                                          |
| Copy file & assign an owner        | sudo install -o nginx config.conf /etc/nginx/ | cp config.conf /etc/nginx/ && chown nginx /etc/nginx/config.conf       |
