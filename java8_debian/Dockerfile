FROM openjdk:8u292-jdk-slim-buster

RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1

# Install dependencies for Bazel
RUN apt-get -y update && apt-get install -y --no-install-recommends ant
