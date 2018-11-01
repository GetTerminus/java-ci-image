FROM openjdk:8u181-jdk-slim-stretch

# Install dependencies for Bazel
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    pkg-config \
    zip \
    g++ \
    zlib1g-dev \
    unzip \
    python \
    wget

ENV BAZEL_VERSION 0.18.0
WORKDIR /tools

RUN wget -nv https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
    chmod u+x ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
    ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh

WORKDIR /
RUN rm -r tools/
