#!/bin/bash

docker rm run-debian2docker
docker build -t debian2docker .
docker run -i -t --privileged --name run-debian2docker debian2docker
docker cp run-debian2docker:/debian2docker.iso .

