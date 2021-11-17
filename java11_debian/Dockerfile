FROM openjdk:11.0.13-jdk-slim-buster

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

WORKDIR /tools

RUN go get github.com/golang/dep/cmd/dep
RUN mkdir $HOME/.docker && \
    echo "{\n  \"credsStore\": \"ecr-login\"\n}" > $HOME/.docker/config.json
RUN go get github.com/GetTerminus/convox-off-cluster-builder/cmd/convox-build-off-cluster

ADD https://convox.com/cli/linux/convox /usr/local/bin/convox
RUN chmod 755 /usr/local/bin/convox

# Maven
ARG MAVEN_VERSION=3.8.3
ARG USER_HOME_DIR="/root"
ARG SHA=1c12a5df43421795054874fd54bb8b37d242949133b5bf6052a063a13a93f13a20e6e9dae2b3d85b9c7034ec977bbc2b6e7f66832182b9c863711d78bfe60faa
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Delete install script (and containing folder)
WORKDIR /
RUN rm -r /tools/
