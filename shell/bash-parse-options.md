# Parse Options

For scripts with more than 1 option, it's usually a great idea to parse those
options like any standard Linux script.

You can start out with only 2 options and add/remove them as you need.

Here's a great way to achieve that. It may seem like a lot, but it's the only
way that I do it anymore.

```shell
#!/bin/bash

set -e

# For details see:
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
getopt --test > /dev/null && true
if [ $? -ne 4 ]; then
    echo 'sorry, getopts --test` failed in this environment'
    exit 1
fi

# Options with a colon must have a value that follows, those without are just booleans.
LONG_OPTS=skip-verify,jobs:,tar-type:,sig-type:
OPTIONS=s,j:,t:

PARSED=$(getopt --options=${OPTIONS} --longoptions=${LONG_OPTS} --name "$0" -- "${@}") || exit 1
eval set -- "${PARSED}"

# Defaults
skip_sig_verify="0"
tar_type="gz"
sig_type="sig"
threads=""

while true; do
    case "${1}" in
        -j|--jobs)
            threads="${2}"
            shift 2
            ;;
        -s|--skip-verify)
            skip_sig_verify="1"
            shift
            ;;
        --sig-type)
            sig_type="${2}"
            shift 2
            ;;
        -t|--tar-type)
            tar_type="${2}"
            shift 2
            ;;
        --) shift; break;;
        *) echo "unknown option '${1}'"; exit 1;;
    esac
done

if [ "$#" -lt 1 ]; then
    echo "the app name is a required first argument"
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "missing required second argument <app semantic version>, ex: 1.0.0 or 1.0"
    exit 1
fi

# Arguments
app_name="${1}"
soft_ver="${2}"
```