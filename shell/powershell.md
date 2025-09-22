# PowerShell

# Set a environment variable that sticks after a power-cycle:

Here we can set a user account variable for ourselves quickly without going
through the UI.

```shell
[Environment]::SetEnvironmentVariable("AWS_PROFILE", "you-aws-profile-here", "User")
```
