#!/usr/bin/env bash
set -euo pipefail

GIT_COMMIT=$(GIT_COMMIT:-latest)
IMAGE="vaibhavgumalwad/myapp:$GIT_COMMIT"

echo "🔐 Logging in to DockerHub..."
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

echo "🐳 Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

echo "📤 Pushing Docker image to DockerHub..."
docker push "$IMAGE"
