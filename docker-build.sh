#!/usr/bin/env bash

ASYNCAPI_FILE="asyncapi-min.yaml"

# Rebuild project
# ./build-asyncapi.sh -d -f "${ASYNCAPI_FILE}"

# Build Docker image
IMAGE_NAME=enviropluspublisher
IMAGE_TAG=v0.1

DOCKER_BUILDKIT=1 docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    --build-arg PORT=8080 \
    --build-arg USER_ID=$(id -u) \
    --build-arg GROUP_ID=$(id -g) \
    .

# Scan Docker image
# docker scan "${IMAGE_NAME}:${IMAGE_TAG}"
