#!/usr/bin/env bash

echo ${CI_OPT_DOCKER_REGISTRY_PASS} | docker login --password-stdin -u="${CI_OPT_DOCKER_REGISTRY_USER}" docker.io

IMAGE_NAME=${IMAGE_PREFIX:-cirepo}/java-8-oracle
IMAGE_VERSION=8u${IMAGE_ARG_JAVA8_VERSION_MINOR}
if [ "${TRAVIS_BRANCH}" != "master" ]; then IMAGE_VERSION=8u${IMAGE_ARG_JAVA8_VERSION_MINOR}-SNAPSHOT; fi

docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} .
docker push ${IMAGE_NAME}:${IMAGE_VERSION}

if [ "${TRAVIS_BRANCH}" == "master" ] && [ "${IMAGE_VERSION}" == "${IMAGE_VERSION_LATEST}" ]; then
    docker tag ${IMAGE_NAME}:${IMAGE_VERSION} ${IMAGE_NAME}:latest
    docker push ${IMAGE_NAME}:latest
fi
