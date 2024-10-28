#!/usr/bin/env -S python -X faulthandler

import os

if os.environ.get('IMPORT_TILEDB'):
    # ❌ When `tiledb` is imported before `tiledbsoma`, a segfault occurs during `open` below
    print("Importing `tiledb` before `tiledbsoma`")
    import tiledb

print("Importing tiledbsoma")
import tiledbsoma
print("Imported tiledbsoma")
import tiledb
print("Imported tiledb")

soma_ctx = tiledbsoma.SOMATileDBContext(tiledb_config={
    "vfs.s3.no_sign_request": "true",
    "vfs.s3.region": "us-west-2",
})
uri = f"s3://cellxgene-census-public-us-west-2/cell-census/2024-07-01/soma/census_data/homo_sapiens"
exp = tiledbsoma.open(uri, context=soma_ctx)
print(exp)
