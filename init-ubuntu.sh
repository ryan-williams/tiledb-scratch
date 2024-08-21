#!/usr/bin/env bash
# Initialize an Ubuntu (ami-0b33ebbed151cf740) instance (m6a.4xlarge)

# https://github.com/runsascoded/.rc?tab=readme-ov-file#quickstart
. <(curl -L https://j.mp/_rc) runsascoded/.rc

# https://github.com/pyenv/pyenv-installer
curl https://pyenv.run | bash

# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt update -y
sudo apt install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install Python base env
v=3.11.9
pyenv install $v
pyenv global $v
pip install --update pip

git clone https://github.com/chanzuckerberg/cellxgene-census
pip install -e cellxgene-census/tools/cellxgene_census_builder

git clone https://github.com/single-cell-data/TileDB-SOMA/
pip install -e TileDB-SOMA/apis/python
