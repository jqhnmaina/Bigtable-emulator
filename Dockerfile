# Build image
FROM python:3-alpine AS build

RUN apk update && apk add curl tar

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-376.0.0-linux-x86_64.tar.gz

RUN tar -xf google-cloud-sdk-376.0.0-linux-x86_64.tar.gz

RUN ./google-cloud-sdk/install.sh

RUN ./google-cloud-sdk/bin/gcloud components install --quiet beta bigtable

# Run image
FROM python:3-alpine

COPY --from=build ./google-cloud-sdk/ .

EXPOSE 8086

ENTRYPOINT ./bin/gcloud beta emulators bigtable start --host-port=0.0.0.0:8086
