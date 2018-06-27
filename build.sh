#!/usr/bin/env bash

if [ -n "${CI_OPT_DOCKER_REGISTRY_PASS}" ] && [ -n "${CI_OPT_DOCKER_REGISTRY_USER}" ]; then
    echo ${CI_OPT_DOCKER_REGISTRY_PASS} | docker login --password-stdin -u="${CI_OPT_DOCKER_REGISTRY_USER}" docker.io
fi

IMAGE_NAME=${IMAGE_PREFIX:-cirepo}/java-8-oracle
IMAGE_TAG=8u${IMAGE_ARG_JAVA8_VERSION_MINOR}
if [ "${TRAVIS_BRANCH}" != "master" ]; then IMAGE_TAG=${IMAGE_TAG}-SNAPSHOT; fi

docker build -t \
    --build-arg IMAGE_ARG_JAVA8_VERSION_MINOR=${IMAGE_ARG_JAVA8_VERSION_MINOR:-171} \
    --build-arg IMAGE_ARG_JAVA8_PACKAGE_DIGEST=${IMAGE_ARG_JAVA8_PACKAGE_DIGEST:-512cd62ec5174c3487ac17c61aaa89e8} \
    ${IMAGE_NAME}:${IMAGE_TAG} .
docker push ${IMAGE_NAME}:${IMAGE_TAG}

if [ "${TRAVIS_BRANCH}" == "master" ] && [ "${IMAGE_TAG}" == "${IMAGE_TAG_LATEST}" ]; then
    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
    docker push ${IMAGE_NAME}:latest
fi
