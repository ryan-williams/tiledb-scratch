FROM ubuntu:22.04

RUN apt update -y \
 && apt install -y cmake curl g++ git make pkg-config \
 && apt install -y python3 python3-pip python-is-python3 python3.10-venv python-dev-is-python3 \
 && rm -rf /var/lib/apt/lists/*

ARG org=single-cell-data
ARG branch=main
RUN git clone -b ${branch} https://github.com/${org}/TileDB-SOMA
WORKDIR TileDB-SOMA

ENTRYPOINT [ "make", "install", "build=Debug" ]
