# Makefile

This is for people that have read Makefile documentation and are familiar with [Makefile-Conventions]

## General

Every Makefile should contain this line:

```makefile
SHELL = /bin/sh
```

Set the suffix list explicitly using only the suffixes you need in the particular Makefile, like this:

```makefile
.SUFFIXES:
.SUFFIXES: .c .o
```

The first line clears out the suffix list, the second introduces all suffixes which may be subject to implicit rules in
this Makefile.

Don't assume that `.` is in the path for command execution. The distinction between `./` (the build directory) and
`$(srcdir)/` (the source directory) is important because users can build in a separate directory using the `--srcdir`
option to configure.

Rely on `VPATH` to find the source file(s):
* In the case where there is a single dependency file use the make automatic variable `$<` to represent the source file
  wherever it is.
* When the target has multiple dependencies, using an explicit `$(srcdir)` is the easiest way to make the rule work.

When generating files with Makefile that are part of the distribution, put them in the $(srcdir), if they are __NOT__
part of the distribution, then leave them out of the $(srcdir).

## Utilities

The configure script and the Makefile rules for building and installation should not use any utilities directly except these:

```text
awk cat cmp cp diff echo expr false grep install-info ln ls
mkdir mv printf pwd rm rmdir sed sleep sort tar test touch tr true
```

Compression programs such as gzip can be used in the dist rule.

Generally, stick to the widely-supported (usually POSIX-specified) options and features of these programs. For example,
don't use `mkdir -p`, convenient as it may be, because a few systems don't support it at all and with others, it is not
safe for parallel execution.

Avoid creating symbolic links in makefiles, since a few file systems don't support them.

Rules for building and installation should use compilers and related programs via make variables so
that the user can substitute alternatives.
## 
* **bindir** - The directory for installing executable programs that users can run. This should normally be
  `/usr/local/bin`, but write it as $(exec_prefix)/bin. (If you are using Autoconf, write it as `@bindir@`.)
* **sbindir** - The directory for installing executable programs that can be run from the shell, but are only generally
  useful to system administrators. This should normally be /usr/local/sbin, but write it as $(exec_prefix)/sbin.
  (If you are using Autoconf, write it as `@sbindir@`.)
* **libexecdir** - The directory for installing executable programs to be run by other programs rather than by users.
  This directory should normally be `/usr/local/libexec`, but write it as `$(exec_prefix)/libexec`. (If you are using
  Autoconf, write it as `@libexecdir@`.)

---

[Makefile-Conventions]: https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html#Makefile-Conventions