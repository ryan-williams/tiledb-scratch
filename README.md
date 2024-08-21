# tiledb-scratchwork

Branches:
- [census-test](https://github.com/ryan-williams/tiledb-scratch/tree/census-test): repro of [TileDB-SOMA#2920](https://github.com/single-cell-data/TileDB-SOMA/issues/2920) (repro [cellxgene_census_builder//test_builder.py](https://github.com/chanzuckerberg/cellxgene-census/blob/main/tools/cellxgene_census_builder/tests/test_builder.py) failure beginning with [TileDB-SOMA#2895](https://github.com/single-cell-data/TileDB-SOMA/pull/2895))
- [import-segfault](https://github.com/ryan-williams/tiledb-scratch/tree/import-segfault): repro of [TileDB-SOMA#2293](https://github.com/single-cell-data/TileDB-SOMA/issues/2293) (importing `tiledb` before `tiledbsoma` can cause segfaults on macOS) 
- [dbg-build](https://github.com/ryan-williams/tiledb-scratch/tree/dbg-build): test [**@teo-tsirpanis**](https://github.com/teo-tsirpanis)'s fix ([`8e3d4de`](https://github.com/teo-tsirpanis/TileDB-SOMA/commit/8e3d4de60abc72378d0b69721980d47ca3f943f1)) for a TileDB-SOMA debug-build issue ([TileDB-SOMA#2244](https://github.com/single-cell-data/TileDB-SOMA/pull/2244))
