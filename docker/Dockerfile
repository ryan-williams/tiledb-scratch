# Install VCPKG
FROM ubuntu:22.04 as vcpkg

RUN apt update \
 && apt install -y cmake curl g++ git make ninja-build tar unzip zip \
 && rm -rf /var/lib/apt/lists/*

# Install/Configure VCPKG
RUN git clone https://github.com/microsoft/vcpkg.git \
 && cd vcpkg \
 && ./bootstrap-vcpkg.sh

# Copy installed VCPKG, build TileDB-SOMA in debug mode
FROM ubuntu:22.04

RUN apt update -y \
 && apt install -y cmake curl g++ git make pkg-config \
 && apt install -y python3 python3-pip python-is-python3 python3.10-venv python-dev-is-python3 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=vcpkg /vcpkg /vcpkg
ENV VCPKG_ROOT=/vcpkg
ENV PATH=$VCPKG_ROOT:$PATH CMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake

ARG editable=-e
ARG branch=main
RUN pip install ${editable} 'git+https://github.com/single-cell-data/TileDB-SOMA@${branch}#egg=tiledbsoma&subdirectory=apis/python/'
