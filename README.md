# TileDB-SOMA spurious `DoesNotExistError`

```bash
pip install tiledbsoma==1.14.5

# Valid Census URI
uri=s3://cellxgene-census-public-us-west-2/cell-census/2024-07-01/soma/census_data/homo_sapiens/ms/RNA/X/raw

# ✅ OK
aws s3 ls $uri

# ❌ DoesNotExistError
python -c "import tiledbsoma; tiledbsoma.open('$uri')"
```

Full output:
```bash
python -c "import tiledbsoma; tiledbsoma.Experiment.open('$uri')"
# Traceback (most recent call last):
#   File "<string>", line 1, in <module>
#   File "/Users/ryan/.pyenv/versions/tiledb-soma-3.11.6/lib/python3.11/site-packages/tiledbsoma/_collection.py", line 156, in open
#     return super().open(
#            ^^^^^^^^^^^^^
#   File "/Users/ryan/.pyenv/versions/tiledb-soma-3.11.6/lib/python3.11/site-packages/tiledbsoma/_soma_object.py", line 97, in open
#     handle = _tdb_handles.open(
#              ^^^^^^^^^^^^^^^^^^
#   File "/Users/ryan/.pyenv/versions/tiledb-soma-3.11.6/lib/python3.11/site-packages/tiledbsoma/_tdb_handles.py", line 77, in open
#     raise DoesNotExistError(f"{uri!r} does not exist")
# tiledbsoma._exception.DoesNotExistError: 's3://cellxgene-census-public-us-west-2/cell-census/2024-07-01/soma/census_data/homo_sapiens/ms/RNA/X/raw' does not exist
```

[`test.py`](test.py):
```python
import sys
from tiledbsoma import Experiment
print(Experiment.open(sys.argv[1]))
```

[Example run] of [gha.yml].


[Example run]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/12014672433/job/33491003361
[gha.yml]: .github/workflows/gha.yml
