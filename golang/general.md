# General

## Add Private Module

We're going to focus on adding private modules, using _github.com_ as an
example.
The Go `GOPRIVATE` environment variable needs to be set so it contains the
repository that you want to use. It takes a comma-separated list of glob
patterns. See [Environment variables] for more information on `GOPRIVATE`.
You may be able to set it with the command:
`go env -w GOPRIVATE="${GOPRIVATE},github.com/<org|*>/<repo|*>"`.

Though not work in Powershell. There are 2 parts. set the environment variable,
and if you use Git with SSH, then you want to have it use ssh instead of HTTPS,
which is what Go defaults to for dependencies. For example, for a private repo:

```shell
export GOPRIVATE="*github.com/<org>/<repository>"
git config --global url."ssh://git@github.com/<org>/<repository>".insteadOf "https://github.com/<org>/<repository>"
go get github.com/<org>/<repository>@0.1.0
```

## Go Work

If you want to develop a project in Go, along with 1 or more dependencies that
will all be separate projects, then workspaces can be a good tool to aid in
their simultaneous development.

As the documentation says:

__"A workspace is specified by a `go.work` file that specifies a set of
module directories with the `use` directive. These modules are used as
root modules by the go command for builds and related operations.  A
workspace that does not specify modules to be used cannot be used to do
builds from local modules."__

I take that to mean even the module your building must be listed in as `use`
statement in the `go.work` file; because if you don't then your builds will fail
stating:

```shell
 go build -C ./cmd/local
current directory is contained in a module that is not one of the workspace modules listed in go.work. You can add the module to the workspace using:
        go work use ..\..
```
NOTE: If no go module is detected, then nothing will be output on the command
line or the go.work file.

See https://go.dev/ref/mod#workspaces for an in-depth reference on
workspaces.

I started out using workspaces as a way to use a local copy of a dependency
that I'm co-developing with a current application I'm working on.

So I start like this.

1. `cd` into the directory that you are working on.
2. Run `go work init .`, or `go work use .` if you already ran init without any
   arguments.
3. Then add your dependency with `go work use github.com/kohirens/stdlib`.
4. Then build `go build -C ./cmd/local`

Go into the Golang project. and type `go work init`, no need to specify the
directory if your already in it. It will automatically use the current directory.
Then just type `go work use <relative/full>` path of the directory where the
dependency module lives.

I stick to relative paths based on src being in my
home directory. This works well when using containers on Windows. 
