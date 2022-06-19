FROM ubuntu:latest AS build

COPY . /build
WORKDIR /build

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y gprbuild gnat && \
    make datadir=/usr/local/share/words commands sorter && \
    make data && mkdir data && \
    cp DICTFILE.GEN STEMFILE.GEN INDXFILE.GEN EWDSLIST.GEN \
       INFLECTS.SEC EWDSFILE.GEN STEMLIST.GEN data/

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y libgnat-10

COPY --from=build /build/bin/* /usr/local/bin/
COPY --from=build /build/data/* /usr/local/share/words/
