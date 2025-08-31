#!/usr/bin/env bash
set -euo pipefail
DOCKER_USER="vaibhavgumalwad"
IMAGE="$DOCKER_USER/myapp:$GIT_COMMIT"
echo "Building $IMAGE"
docker build -t $IMAGE .
docker push $IMAGE
