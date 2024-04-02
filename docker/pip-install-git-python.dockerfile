# `pip install -e` tiledbsoma via git+https URL, without installing VCPKG first
FROM python:3.11.8

RUN apt update \
 && apt install -y cmake curl g++ git make ninja-build tar unzip zip \
 && rm -rf /var/lib/apt/lists/*

ARG editable=-e
ARG ref=main
RUN pip install ${editable} "git+https://github.com/single-cell-data/TileDB-SOMA@${ref}#egg=tiledbsoma&subdirectory=apis/python/"
