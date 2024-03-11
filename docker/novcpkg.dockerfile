# Attempt to build TileDB-SOMA in debug mode, without VCPKG present, testing Teo's fix
FROM ubuntu:22.04

RUN apt update -y \
 && apt install -y cmake curl g++ git make pkg-config \
 && apt install -y python3 python3-pip python-is-python3 python3.10-venv python-dev-is-python3 \
 && rm -rf /var/lib/apt/lists/*

# Needed for vcpkg install
RUN apt update -y \
 && apt install -y curl zip unzip tar \
 && rm -rf /var/lib/apt/lists/*

# Use org=teo-tsirpanis branch=toolchain-fix to test fix
ARG org=single-cell-data
ARG branch=main
RUN git clone -b ${branch} https://github.com/${org}/TileDB-SOMA
WORKDIR TileDB-SOMA
RUN echo '1.9.0rc0' > apis/python/RELEASE-VERSION

# Optionally skip failing build (allowing shelling in for interactive debugging)
ARG build=1
RUN test -z "$build" || make install build=Debug

ENTRYPOINT [ "make", "install", "build=Debug" ]
