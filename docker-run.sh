#!/usr/bin/env bash

IMAGE_NAME=enviropluspublisher
IMAGE_TAG=v0.1

docker run -d -e PYTHONUNBUFFERED=1 --name "${IMAGE_NAME}" -p 80:80 -p 1883:1883 -p 9001:9001 "${IMAGE_NAME}:${IMAGE_TAG}"
