#!/bin/bash

set -exv

IMAGE="quay.io/cloudservices/kubedock"
IMAGE_TAG=$(git rev-parse --short=7 HEAD)

docker build -t "${IMAGE}:${IMAGE_TAG}" .
