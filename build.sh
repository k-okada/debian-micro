#!/bin/bash

set -e

docker rm run-debian2docker
echo "Building image..."
docker build -t debian2docker .
echo "Running container..."
docker run -i -t --privileged --name run-debian2docker debian2docker
docker cp run-debian2docker:/debian2docker.iso .

chown virtual:virtual ./debian2docker.iso
mv debian2docker.iso /home/virtual/Downloads/debian2docker.iso
ls -lh /home/virtual/Downloads/debian2docker.iso
