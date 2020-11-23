#!/usr/bin/env bash

IMAGE_NAME=enviropluspublisher
IMAGE_TAG=v0.1

docker run -d --rm \
    --name "${IMAGE_NAME}" \
    -e PYTHONUNBUFFERED=1 \
    -p 8080:8080 -p 1883:1883 -p 9001:9001 \
    "${IMAGE_NAME}:${IMAGE_TAG}"
