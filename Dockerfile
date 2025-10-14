FROM ubuntu:24.04

# https://github.com/openstreetmap/osmosis/releases
ENV OSMOSIS_VERSION=0.49.2

# https://github.com/mapsforge/mapsforge
ENV MAPSFORGE_VERSION=0.26.1

# base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y ca-certificates
RUN update-ca-certificates

# wget
RUN apt-get install -y --no-install-recommends wget

# download osmosis
RUN wget https://github.com/openstreetmap/osmosis/releases/download/${OSMOSIS_VERSION}/osmosis-${OSMOSIS_VERSION}.tar

# install osmosis
RUN tar -xvf osmosis-${OSMOSIS_VERSION}.tar -C /usr/local/ && ln -s /usr/local/osmosis-${OSMOSIS_VERSION} /usr/local/osmosis
RUN ln -s /usr/local/osmosis/bin/osmosis /usr/bin

# download mapsforge-map-writer
RUN wget https://github.com/mapsforge/mapsforge/releases/download/${MAPSFORGE_VERSION}/mapsforge-map-writer-${MAPSFORGE_VERSION}-jar-with-dependencies.jar

# install mapsforge-map-writer
RUN mv mapsforge-map-writer-${MAPSFORGE_VERSION}-jar-with-dependencies.jar /usr/local/osmosis/lib/

# install java
RUN apt-get install -y --no-install-recommends default-jre-headless \
    libslf4j-java

USER 1000:1000

WORKDIR /data