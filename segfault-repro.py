#!/usr/bin/env python -X faulthandler

import os

if os.environ.get('IMPORT_TILEDB'):
    # ❌ When `tiledb` is imported before `tiledbsoma`, a segfault occurs during `open` below
    import tiledb

import tiledbsoma


print(tiledbsoma.Experiment.open("pbmc-small"))
