#!/usr/bin/env bash

set -ex

# . <(curl -L https://j.mp/_rc) runsascoded/.rc
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y
sudo apt-get install -y cmake curl g++ git make pkg-config python3 python3-pip python-is-python3 python3.10-venv python-dev-is-python3 unzip zip

git clone https://github.com/single-cell-data/TileDB-SOMA
cd TileDB-SOMA/

python -m venv venv
. venv/bin/activate
python -V

time make install build=Debug
cd apis/python
pip install -e .[dev]

python scripts/show-versions.py
