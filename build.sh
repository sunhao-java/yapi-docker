#! /bin/bash
YAPI_VERSION=1.9.2

docker build -t sunhaojava/yapi:${YAPI_VERSION} --build-arg YAPI_VERSION=${YAPI_VERSION} .