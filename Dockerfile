FROM golang:1.9-alpine3.6

MAINTAINER Ewan Valentine <ewan.valentine89@gmail.com>

RUN apk update && apk add docker openrc --no-cache
