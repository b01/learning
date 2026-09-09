# General

Notes for in general everyday shelling.

Be sure to also check out [Bash Features] for all your Bashy needs!

## Unix Philosophy

1. Write programs that do one thing and do it well.
2. Write programs to work together.
3. Write programs to handle text streams, because that is a universal interface.

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

## Tar Usage

To tar a directory, use the command to create an uncompressed archive, or to
create a compressed gzip archive. The flag creates, shows progress, defines
the file name, and compresses.

Create a .tar.gz archive (compressed):

```shell
tar -czvf archive.tar.gz /path/to/directory
```

Key Options Breakdown

`-c` - Create a new archive.
`-v` - Verbose; list files as they are processed.
`-f` - Filename; specifies the name of the archive file.
`-z` - Compress with gzip.

Extract a tar file use `tar -xvf archive.tar`.

## While Loops

Loop through lines in a file

```shell
# Make a test file.
cat <<TXT | tee test-input-01.txt
01 02 03
04
05 06 07
TXT

# Loop over the file.
while read var1 var2 var3
do
   echo "var1 = ${var1}, var2 = ${var2}, var3 = ${var3}"
done < test-input-01.txt
```

`read` will read each word into a variable
`while` will loop on every newline and end on EOF.
Input is taken after `done`.
The structure of the look is also important:+
```shell
while <test>
do
    <commands>
done <optional>
```

## Send Output to File and Stdout

```shell
echo "Salam" | tee -a /var/log/worker.log
```

---

[Bash Features]: https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html