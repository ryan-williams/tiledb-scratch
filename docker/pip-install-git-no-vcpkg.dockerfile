# `pip install -e` tiledbsoma via git+https URL, without installing VCPKG first
FROM ubuntu:22.04

RUN apt update -y \
 && apt install -y cmake curl g++ git make pkg-config \
 && apt install -y python3 python3-pip python-is-python3 python3.10-venv python-dev-is-python3 \
 && rm -rf /var/lib/apt/lists/*

ARG editable=-e
ARG branch=main
RUN pip install ${editable} "git+https://github.com/single-cell-data/TileDB-SOMA@${branch}#egg=tiledbsoma&subdirectory=apis/python/"
