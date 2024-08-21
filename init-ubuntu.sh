#!/usr/bin/env bash
# Initialize an Ubuntu (ami-0b33ebbed151cf740) instance (m6a.4xlarge), repro https://github.com/single-cell-data/TileDB-SOMA/issues/2920:
# ```bash
# bash -i <(curl https://raw.githubusercontent.com/ryan-williams/tiledb-scratch/census-test/init-ubuntu.sh) [commits to test...; current `main`, by default]
# ```

set -ex

# Optional dotfiles https://github.com/runsascoded/.rc?tab=readme-ov-file#quickstart
if [ "$1" == "-d" ]; then
    . <(curl -L https://j.mp/_rc) runsascoded/.rc
fi

# Install pyenv: https://github.com/pyenv/pyenv-installer
curl https://pyenv.run | bash
cat >>.bashrc <<EOF
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF
. ~/.bashrc
which pyenv

# Install Python deps: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt update -y
sudo apt install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install Python base env
v=3.11.9
pyenv install $v
pyenv global $v
pip install --upgrade pip pytest

git clone https://github.com/single-cell-data/TileDB-SOMA
git clone https://github.com/chanzuckerberg/cellxgene-census
pip install -e cellxgene-census/tools/cellxgene_census_builder

cat >test.sh <<EOF
#!/usr/bin/env bash
for arg in "\$@"; do
    cd ~/TileDB-SOMA
    echo "Testing \$arg"
    git checkout "\$arg"
    git --no-pager log -1
    make clean
    pip install -e apis/python
    cd ~/cellxgene-census/tools/cellxgene_census_builder
    pytest tests/test_builder.py && echo "✅ \$arg succeeded" || echo "❌ \$arg failed"
done
EOF
chmod 755 test.sh

# ./test.sh 7241fef7   # ❌ fails
# ./test.sh 7241fef7^  # ✅ passes

if [ $# -eq 0 ]; then
    set -- main
fi
./test.sh "$@"
