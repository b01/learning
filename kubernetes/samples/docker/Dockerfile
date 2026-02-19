FROM ubuntu

WORKDIR /tmp
ARG GO_VER="1.26.1"
RUN apt update \
 && apt install -y \
        curl \
        git \
        make \
        unzip \
        zip

RUN curl -LO https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz --strip-components=1

RUN curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

ENV GOPATH /root
ENV PATH="${PATH}:/root/bin"
ENV CGO_ENABLED=0

RUN git clone https://github.com/kubernetes/cloud-provider-aws.git

COPY --chmod=755 start.sh /usr/local/bin

ENTRYPOINT [ "start.sh" ]