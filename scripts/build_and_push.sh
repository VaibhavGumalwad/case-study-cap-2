#!/usr/bin/env bash
set -euo pipefail

GIT_COMMIT=$(GIT_COMMIT:-latest)
IMAGE="vaibhavgumalwad/myapp:$GIT_COMMIT"

echo "🐳 Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

echo "📤 Pushing Docker image to DockerHub..."
docker push "$IMAGE"
