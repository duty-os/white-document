#! /bin/bash
set -exo pipefail
docker build -t white-develop-document:latest .
docker tag white-develop-document:latest registry.cn-hangzhou.aliyuncs.com/white/white-develop-document:latest
docker push registry.cn-hangzhou.aliyuncs.com/white/white-develop-document:latest
