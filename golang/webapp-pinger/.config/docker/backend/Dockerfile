ARG REPO='github.com/b01/learning'
ARG SEMVER
ARG GOLANG_VER='1.24'

# Use an official Python runtime as a parent image
FROM golang:${GOLANG_VER}-alpine3.22 AS base

# Update OS
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk --no-progress --purge --no-cache upgrade \
 && apk add \
        curl \
        openssl \
        tzdata \
 && rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/*

ENV SHELL=/bin/sh
ENV TZ=America/Detroit

HEALTHCHECK --interval=5s --timeout=3s --start-period=3s --retries=4 \
    CMD curl -k -f https://localhost/

FROM base AS dev

ARG REPO

# Install development apps
RUN apk add \
        jq \
        openssl \
        zip \
 && rm -vrf /var/cache/apk/* \
 && rm -rf /tmp/*

RUN curl -L -o gen-ss-cert.sh https://raw.githubusercontent.com/b01/script-lib/refs/heads/main/generate-self-signed-cert.sh \
 && chmod 555 ./gen-ss-cert.sh \
 && mv gen-ss-cert.sh /usr/local/bin

ENV PATH="${PATH}:/root/bin"
ENV GOPATH /root
ENV CGO_ENABLED=0

# Set the working directory in the container
WORKDIR "/root/src/${REPO}/golang/webapp-pinger"

COPY --chmod=644 .config/docker/.gitconfig /root
COPY --chmod=755 .config/docker/start.sh /usr/local/bin
COPY --chmod=744 . .

RUN go mod tidy

# Remember -C must be the first option; see go help build `-C` for explanation.
RUN go build -C . -o app \
 && mv ./app /usr/local/bin

ENTRYPOINT [ "start.sh" ]

# Run app.py when the container launches
CMD [ "" ]

# Make port 5000 available to the world outside this container
EXPOSE 443/tcp

STOPSIGNAL SIGINT
