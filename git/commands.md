# Git Commands

This is just a cheat sheet of my own personal forgot-chas.

**Use SSH over HTTPS**

`git config --global url."ssh://git@github.com/<org>".insteadOf "https://github.com/<org>"`

NOTE: We use a **"/"** instead of **":"**. There should be an error if you use
the wrong symbol after the hostname and before the organization, but in case
there is not. There may be another format that would take **":"**
maybe if you drop the **"ssh://"**. I have not spent the time to try it out.