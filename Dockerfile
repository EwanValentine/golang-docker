FROM golang:1.9

MAINTAINER Ewan Valentine <ewan.valentine89@gmail.com>

RUN apt-get update && apt-get -y install docker && echo ${HOME}

RUN echo $(eval echo ${APP_NAME})

ENV GCLOUD_PROJECT_NAME=tabb-168314
ENV GCLOUD_CLUSTER_NAME=dev
ENV CLOUDSDK_COMPUTE_ZONE=europe-west1-b
ENV DOCKER_TAG_PREFIX="eu.gcr.io/$GCLOUD_PROJECT_NAME/$(eval echo ${APP_NAME})"
ENV DOCKER_TAG="$DOCKER_TAG_PREFIX:$CIRCLE_SHA1"
ENV GOOGLE_APPLICATION_CREDENTIALS="$HOME/gcloud-service-key.json"
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1

RUN curl https://sdk.cloud.google.com | bash && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

RUN echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/gcloud-service-key.json && \
    ~/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json && \
    ~/google-cloud-sdk/bin/gcloud config set project $GCLOUD_PROJECT_NAME && \
    ~/google-cloud-sdk/bin/gcloud --quiet config set container/cluster $GCLOUD_CLUSTER_NAME && \
    ~/google-cloud-sdk/bin/gcloud config set compute/zone $CLOUDSDK_COMPUTE_ZONE && \
    ~/google-cloud-sdk/bin/gcloud --quiet container clusters get-credentials $GCLOUD_CLUSTER_NAME
