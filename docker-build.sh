#!/usr/bin/env bash

ASYNCAPI_FILE="asyncapi-min.yaml"

# Rebuild project
# ./build-asyncapi.sh -d -f "${ASYNCAPI_FILE}"

# Build Docker image
IMAGE_NAME=enviropluspublisher
IMAGE_TAG=v0.1

DOCKER_BUILDKIT=1 docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

# Scan Docker image
# docker scan "${IMAGE_NAME}:${IMAGE_TAG}"
