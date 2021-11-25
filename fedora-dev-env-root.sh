#!/bin/bash
docker run --device /dev/fuse \
           --cap-add SYS_ADMIN \
           -v dev-home-tssu:/home/tssu \
           -v dev-opt:/opt \
           -e TERM=$TERM \
           -u root \
           --rm -it \
           stanso/fedora-dev-env

           # -v ~/Projects/docker-dev-data/home:/home/tssu \
           # -v ~/Projects/docker-dev-data/opt:/opt \
