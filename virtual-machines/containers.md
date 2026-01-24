# Containers

General issues you can run into when working with containers.

## Docker and Go Workspaces

This can be an amazing combo and greatly speed up development. Howerver, it can
be tricky the first few times or if you haven't used it in a while.

1. `cd` into your project and run `go work init .` the dot there is important
   because it tells go that this current directory is also part of the root.
  I'm not sure why that is not the default at the time of writing, because if
  you don't add the dot, then when you try to build you'll get an error about
  the current directory not being part of the workspace and fails to build.
2. Next add your dependencies that you want, I prefer to use a relative path
   to the local copy, since I keep everything in $HOME/src, it works in the
   container as well.
   NOTE: Test by building outside the container to make sure the paths are
   correct. I always have to edit the `go.work` for to change the backslashes
   to forward slashes on Windows.
3. Next you'll need to add the dependencies to your Docker Compose config as
   additional context, for example:
   ```yaml
            additional_contexts:
              - example-repo=../../../../octocat/example-repo
   ```
4. This allows them to be added to the context so that you can copy them into
   the image:
   ```Dockerfile
   COPY --from=example-repo --chown=${USER_NAME}:${USER_NAME} / /home/${USER_NAME}/src/github.com/octocat/example-repo/
   ```
   NOTE: The `--from` matches the name of the additional context item before the
   equal sign.
5. If the dependency is a private repository and you wish to use HTTPS to
   download the module, then you can provide `git` credentials using a `.netrc`
   file; which it will use to access the repository. Place the file in the
   $HOME directory of the container user.
   NOTE: It may be better if you generate a fine-grained access token rather
   than use your password. That should avoid the MFA and be more team friendly.
   I prefer this method `https://go.dev/doc/faq#git_https` over SSH since I only
   need to provide a single file instead of a directory.
6. Optionally you can use SSH, generating .ssh or mapping a volume in the
   container to download from repositories. Be sure to add any hosts to
   `~/.ssh/known_hosts`, or you will get errors.
7. Also do not forget to add `git` and `openssh` to the image before building
   the first time.