#!/bin/sh

# We'll use this script to manage starting and stopping this container gracefully.
# It only takes up about 00.01 CPU % allotted to the container, you can verify
# by running `docker stats` after you start a container that uses this as
# as the CMD.

set -e

shutd () {
    printf "%s" "Shutting down the container gracefully..."
    # You can run clean commands here!
    last_signal="15"
}

trap 'shutd' TERM

echo "ready!"

cd cloud-provider-aws
git checkout -b tag-v1.34.2 v1.34.2

printf "%s" "building ecr-credential-provider..."
make ecr-credential-provider
echo "done"

printf "%s" "copy out of container..."
cp ecr-credential-provider /root/kubernetes-assets/
echo "done"

if [ -n "${BUCKET_NAME}" ]; then
  printf "%s" "uploading to s3..."
  aws s3 cp ecr-credential-provider s3://${BUCKET_NAME}/
  echo "done"
fi
