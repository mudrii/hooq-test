#!/bin/sh -v

amazon-linux-extras install docker -y && \
systemctl start docker && \
docker run -d -p 80:80 nginx:alpine