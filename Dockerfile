FROM golang:1.9

MAINTAINER Ewan Valentine <ewan.valentine89@gmail.com>

RUN apt-get update && apt-get -y install docker
