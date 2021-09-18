#!/bin/bash
docker run --device /dev/fuse \
           --cap-add SYS_ADMIN \
           -v ~/Projects/docker-dev-data/home:/home/tssu \
           -v ~/Projects/docker-dev-data/opt:/opt \
           -e TERM=$TERM \
           -u root \
           --rm -it \
           stanso/fedora-dev-env

