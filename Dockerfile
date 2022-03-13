# Build image
FROM alpine AS build

RUN apk update && apk add curl tar

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-376.0.0-linux-x86_64.tar.gz

RUN tar -xf google-cloud-sdk-376.0.0-linux-x86_64.tar.gz

# Install gcloud SDK and run image
FROM python:3-alpine

COPY --from=build /google-cloud-sdk ./gcloud-sdk

RUN ./gcloud-sdk/install.sh

RUN ./gcloud-sdk/bin/gcloud components install --quiet bigtable beta

EXPOSE 8086

CMD ["./gcloud-sdk/bin/gcloud", "beta", "emulators", "bigtable", "start"]
