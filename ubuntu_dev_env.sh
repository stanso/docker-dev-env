#!/bin/bash
docker run --device /dev/fuse \
           --cap-add SYS_ADMIN \
           -v ~/Projects/docker-dev-env/ubuntu-data/home:/home/tssu \
           -v ~/Projects/docker-dev-env/ubuntu-data/opt:/opt \
           -e TERM=$TERM \
           --rm -it \
           stanso/ubuntu-dev-env

