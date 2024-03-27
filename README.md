# macOS segfault: `tiledb{,soma}` import order

On M1 macs (and sometimes on Intel Macs), `tiledbsoma.Experiment.open` segfaults when `tiledb` is imported before `tiledbsoma`:
```bash
IMPORT_TILEDB=  ./segfault-repro.py  # ✅ OK
IMPORT_TILEDB=1 ./segfault-repro.py  # ❌ segfaults when `tiledb` is imported before `tiledbsoma`
# Fatal Python error: Segmentation fault
#
# Current thread 0x00000001da769000 (most recent call first):
#   File "$SITE_PACKAGES/tiledbsoma/_tdb_handles.py", line 58 in open
#   File "$SITE_PACKAGES/tiledbsoma/_tiledb_object.py", line 95 in open
#   File "$PWD/segfault-repro.py", line 12 in <module>
#
# Extension modules: numpy.core._multiarray_umath, numpy.core._multiarray_tests, numpy.linalg._umath_linalg, numpy.fft._pocketfft_internal, numpy.random._common, numpy.random.bit_generator, numpy.random._bounded_integers, numpy.random._mt19937, numpy.random.mtrand, numpy.random._philox, numpy.random._pcg64, numpy.random._sfc64, numpy.random._generator, tiledb.libtiledb, pyarrow.lib, pyarrow._hdfsio, h5py._errors, h5py.defs, h5py._objects, h5py.h5, h5py.utils, h5py.h5t, h5py.h5s, h5py.h5ac, h5py.h5p, h5py.h5r, h5py._proxy, h5py._conv, h5py.h5z, h5py.h5a, h5py.h5d, h5py.h5ds, h5py.h5g, h5py.h5i, h5py.h5f, h5py.h5fd, h5py.h5pl, h5py.h5o, h5py.h5l, h5py._selector, pandas._libs.tslibs.ccalendar, pandas._libs.tslibs.np_datetime, pandas._libs.tslibs.dtypes, pandas._libs.tslibs.base, pandas._libs.tslibs.nattype, pandas._libs.tslibs.timezones, pandas._libs.tslibs.fields, pandas._libs.tslibs.timedeltas, pandas._libs.tslibs.tzconversion, pandas._libs.tslibs.timestamps, pandas._libs.properties, pandas._libs.tslibs.offsets, pandas._libs.tslibs.strptime, pandas._libs.tslibs.parsing, pandas._libs.tslibs.conversion, pandas._libs.tslibs.period, pandas._libs.tslibs.vectorized, pandas._libs.ops_dispatch, pandas._libs.missing, pandas._libs.hashtable, pandas._libs.algos, pandas._libs.interval, pandas._libs.lib, pyarrow._compute, pandas._libs.ops, pandas._libs.hashing, pandas._libs.arrays, pandas._libs.tslib, pandas._libs.sparse, pandas._libs.internals, pandas._libs.indexing, pandas._libs.index, pandas._libs.writers, pandas._libs.join, pandas._libs.window.aggregations, pandas._libs.window.indexers, pandas._libs.reshape, pandas._libs.groupby, pandas._libs.json, pandas._libs.parsers, pandas._libs.testing, scipy._lib._ccallback_c, scipy.sparse._sparsetools, _csparsetools, scipy.sparse._csparsetools, scipy.linalg._fblas, scipy.linalg._flapack, scipy.linalg.cython_lapack, scipy.linalg._cythonized_array_utils, scipy.linalg._solve_toeplitz, scipy.linalg._flinalg, scipy.linalg._decomp_lu_cython, scipy.linalg._matfuncs_sqrtm_triu, scipy.linalg.cython_blas, scipy.linalg._matfuncs_expm, scipy.linalg._decomp_update, scipy.sparse.linalg._dsolve._superlu, scipy.sparse.linalg._eigen.arpack._arpack, scipy.sparse.csgraph._tools, scipy.sparse.csgraph._shortest_path, scipy.sparse.csgraph._traversal, scipy.sparse.csgraph._min_spanning_tree, scipy.sparse.csgraph._flow, scipy.sparse.csgraph._matching, scipy.sparse.csgraph._reordering, numba.core.typeconv._typeconv, numba._helperlib, numba._dynfunc, numba._dispatcher, numba.core.runtime._nrt_python, numba.np.ufunc._internal, numba.experimental.jitclass._box (total: 112)
# Segmentation fault: 11
```

The last line reported is [here](https://github.com/single-cell-data/TileDB-SOMA/blob/1.8.1/apis/python/src/tiledbsoma/_tdb_handles.py#L58) in `_tdb_handles.open`, where it calls into libtiledbsoma:
```python
soma_object = clib.SOMAObject.open(
    uri, open_mode, context.native_context, timestamp=(0, timestamp_ms)
)
```

See [segfault-repro.py](segfault-repro.py).

## Github Actions repros
The segfault seems to happen deterministically on M1 macs ([1][GHA mac M1 fail 3], [2][GHA mac M1 fail 2], [3][GHA mac M1 fail 1]), and non-deterministically on x86 macs ([1][GHA mac intel fail 1]).

Intel mac GHA runs usually succeed ([1][GHA mac intel ok 3], [2][GHA mac intel ok 2], [3][GHA mac intel ok 1]), but output:
```
Error: 3-27 14:51:23.364] [Process: 2862] [error] [1711551083364855000-Global] TileDB internal: mutex lock failed: Invalid argument
```

I've also seen that message on failing M1 mac runs; not sure if it's related.

[GHA mac M1 fail 3]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8454246138/job/23158822528#step:5:23
[GHA mac M1 fail 2]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8454148754/job/23158505366#step:5:23
[GHA mac M1 fail 1]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8453924156/job/23157762661#step:5:23
[GHA mac intel fail 1]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8453924156/job/23157762147#step:5:23
[GHA mac intel ok 1]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8453784557/job/23157281978#step:5:12
[GHA mac intel ok 2]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8453872832/job/23157599348#step:5:15
[GHA mac intel ok 3]: https://github.com/ryan-williams/tiledb-scratch/actions/runs/8454246138/job/23158821889#step:5:15
