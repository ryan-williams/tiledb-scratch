FROM ubuntu:22.04 as vcpkg

RUN apt update \
 && apt install -y cmake curl g++ git make ninja-build tar unzip zip \
 && rm -rf /var/lib/apt/lists/*

# Install/Configure VCPKG
RUN git clone https://github.com/microsoft/vcpkg.git \
 && cd vcpkg \
 && ./bootstrap-vcpkg.sh

FROM ubuntu:22.04

RUN apt update -y \
 && apt install -y cmake curl g++ git make pkg-config \
 && apt install -y python3 python3-pip python-is-python3 python3.10-venv python-dev-is-python3 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=vcpkg /vcpkg /vcpkg
ENV VCPKG_ROOT=/vcpkg
ENV PATH=$VCPKG_ROOT:$PATH CMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake

RUN git clone https://github.com/single-cell-data/TileDB-SOMA
WORKDIR TileDB-SOMA
RUN echo '1.9.0rc0' > apis/python/RELEASE-VERSION

ARG build=1
RUN test -z "$build" || make install build=Debug

ENTRYPOINT [ "make", "install", "build=Debug" ]
