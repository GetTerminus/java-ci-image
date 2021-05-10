FROM openjdk:11.0.11-jdk-slim-buster

# https://github.com/geerlingguy/ansible-role-java/issues/64 - Remediates a bug (workaround)
RUN mkdir /usr/share/man/man1/

# Install dependencies for Bazel
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    pkg-config \
    zip \
    g++ \
    zlib1g-dev \
    unzip \
    python \
    wget \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    software-properties-common \
    ant

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && apt-get install -y docker-ce

RUN wget https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xvf go1.15.2.linux-amd64.tar.gz

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ENV BAZEL_VERSION 1.1.0
WORKDIR /tools

RUN go get github.com/golang/dep/cmd/dep
RUN mkdir $HOME/.docker && \
    echo "{\n  \"credsStore\": \"ecr-login\"\n}" > $HOME/.docker/config.json
RUN go get github.com/GetTerminus/convox-off-cluster-builder/cmd/convox-build-off-cluster

ADD https://convox.com/cli/linux/convox /usr/local/bin/convox
RUN chmod 755 /usr/local/bin/convox

# Download and execute Bazel install script
RUN wget -nv https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
    chmod u+x ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
    ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh

# Extract installation
RUN bazel license > /dev/null

# Delete install script (and containing folder)
WORKDIR /
RUN rm -r /tools/
