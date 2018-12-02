#!/bin/sh -v

amazon-linux-extras install docker -y && \
systemctl start docker && \
docker run -p 80:3000 -d --name docker-node alvarow/docker-node
