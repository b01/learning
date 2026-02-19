# Git Commands

This is just a cheat sheet of my own personal forgot-chas.

**Use SSH over HTTPS**

`git config --global url."ssh://git@github.com/<org>".insteadOf "https://github.com/<org>"`

NOTE: We use a **"/"** instead of **":"**. There should be an error if you use
the wrong symbol after the hostname and before the organization, but in case
there is not. There may be another format that would take **":"**
maybe if you drop the **"ssh://"**. I have not spent the time to try it out.


**Use Debugging**

Enable verbose/debug logging to see where the process is failing.
For git, you can run `export GIT_CURL_VERBOSE=1` before your command to get
detailed output. This works with Go since it relies on Git to download
dependencies.

**Use .netrc**

If you wish to use HTTPS to download the module, then you can provide `git`
credentials using a `.netrc` file; which it will use to access the repository.
Place the file in the $HOME directory of the container user. For example:

Please pay attention to the fact that a token is tied to an organization.
So make sure you use the correct one.
```text
machine github.com login <username> password <personal-access-token>
```

Remove a deleted file from staging with `git restore --staged <delete-file>`.