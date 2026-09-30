# Linux Permissions

Manage system security by controlling access via numeric (octal) or symbolic
codes. They are categorized by three distinct user classes: the owner (User),
the group, and everyone else (Others). [1, 2]

## Permission Component Values

Every set of permissions is calculated using individual base scores:

* `4` = Read (`r`)
* `2` = Write (`w`)
* `1` = Execute (`x`)
* `0` = No permission (`-`) [1, 4]

## Combined Octal Digit Meanings

By adding these scores together, you create a single digit (0–7) for each user class:

* `7` = Read, Write, and Execute (`4 + 2 + 1`)
* `6` = Read and Write (`4 + 2`)
* `5` = Read and Execute (`4 + 1`)
* `4` = Read only
* `3` = Write and Execute (`2 + 1`)
* `2` = Write only
* `1` = Execute only
* `0` = No access [4, 5, 9]

Common Permission Configurations

| Octal Code | Symbolic    | Best Used For                                     |
|------------|-------------|---------------------------------------------------|
| `777`      | `rwxrwxrwx` | Public files (Dangerous; completely unrestricted) |
| `755`      | `rwxr-xr-x` | Web directories and executable scripts            |
| `644`      | `rw-r--r--` | Standard public files (text, images, HTML)        |
| `700`      | `rwx------` | Private executable scripts and private folders    |
| `600`      | `rw-------` | Private data files and private SSH keys           |

## Quick System Commands

Use these commands in your shell to check and change file states:

• Use `ls -l` via the terminal to view active folder permissions.
• Use  to change a file's permission settings. [10, 11, 12]

Would you like to learn how to apply these commands recursively to folders, or do you need help calculating a specific custom combination?

AI responses may include mistakes.

[1] https://www.redhat.com/en/blog/linux-file-permissions-explained
[2] https://www.youtube.com/watch?v=o_2aXxEqtao
[3] https://www.computerhope.com/unix/uchmod.htm
[4] https://www.warp.dev/terminus/linux-file-permissions-explained
[5] https://contabo.com/blog/linux-permission-basics/
[6] https://blog.ronin.cloud/linux-file-permissions/
[7] https://medium.com/@ByteCodeBlogger/everything-you-need-to-know-about-chmod-file-permissions-in-unix-7538745d2475
[8] https://www.pass4sure.com/blog/understanding-linux-file-permissions-a-simple-guide/
[9] https://docs.nersc.gov/filesystems/unix-file-permissions/
[10] https://www.youtube.com/watch?v=5UZ76TCaHr4
[11] https://hcc.unl.edu/docs/handling_data/data_storage/linux_file_permissions/
[12] https://linuxize.com/post/chmod-command-in-linux/

