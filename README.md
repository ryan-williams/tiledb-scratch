# TileDB-SOMA build=Debug fix
Testing [**@teo-tsirpanis**](https://github.com/teo-tsirpanis)'s fix for a TileDB-SOMA debug-build issue: [`8e3d4de`](https://github.com/teo-tsirpanis/TileDB-SOMA/commit/8e3d4de60abc72378d0b69721980d47ca3f943f1).

```bash
cd docker
# ❌ base case: `make install build=Debug` fails:
# vcpkg missing, and CMAKE_TOOLCHAIN_FILE is empty (but set)
docker build -t no-vcpkg -f no-vcpkg.dockerfile .
# ✅ fix: `make install build=Debug` succeeds:
docker build -t no-vcpkg -f no-vcpkg.dockerfile --build-arg org=teo-tsirpanis --build-arg branch=toolchain-fix .
# ✅ normal trunk build: vcpkg present, build succeeds:
docker build -t vcpkg -f vcpkg.dockerfile .
```

Examining the failure in the first case:

```bash
docker build -t no-vcpkg -f no-vcpkg.dockerfile --build-arg build= .
docker run --rm -it --entrypoint bash no-vcpkg -c 'make install build=Debug || cat /TileDB-SOMA/build/externals/src/ep_tiledb-stamp/ep_tiledb-configure-err.log'
```
The initial build fails with:
```
CMake Error at /TileDB-SOMA/build/externals/src/ep_tiledb-stamp/ep_tiledb-configure-Debug.cmake:49 (message):
  Command failed: 1

   '/usr/bin/cmake' '-DCMAKE_INSTALL_PREFIX=/TileDB-SOMA/build/externals/install' '-DCMAKE_PREFIX_PATH=/TileDB-SOMA/build/externals/install' '-DTILEDB_S3=ON' '-DTILEDB_AZURE=ON' '-DTILEDB_GCS=OFF' '-DTILEDB_HDFS=OFF' '-DTILEDB_SERIALIZATION=ON' '-DTILEDB_WERROR=OFF' '-DTILEDB_VERBOSE=OFF' '-DTILEDB_TESTS=OFF' '-DCMAKE_BUILD_TYPE=Debug' '-DCMAKE_OSX_ARCHITECTURES=' '-DCMAKE_C_FLAGS=' '-DCMAKE_CXX_FLAGS=' '-DCMAKE_CXX_COMPILER=/usr/bin/c++' '-DCMAKE_C_COMPILER=/usr/bin/cc' '-DCMAKE_TOOLCHAIN_FILE=' '-DCMAKE_POSITION_INDEPENDENT_CODE=ON' '-GUnix Makefiles' '/TileDB-SOMA/build/externals/src/ep_tiledb'

  See also

    /TileDB-SOMA/build/externals/src/ep_tiledb-stamp/ep_tiledb-configure-*.log


gmake[3]: *** [CMakeFiles/ep_tiledb.dir/build.make:92: externals/src/ep_tiledb-stamp/ep_tiledb-configure] Error 1
gmake[2]: *** [CMakeFiles/Makefile2:89: CMakeFiles/ep_tiledb.dir/all] Error 2
gmake[1]: *** [Makefile:91: all] Error 2
make: *** [Makefile:16: install] Error 2
```

The error log contains:
```
Using vcpkg features: azure;serialization;s3;webp
CMake Error at /usr/share/cmake-3.22/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
  Could NOT find BZip2 (missing: BZIP2_LIBRARIES BZIP2_INCLUDE_DIR)
Call Stack (most recent call first):
  /usr/share/cmake-3.22/Modules/FindPackageHandleStandardArgs.cmake:594 (_FPHSA_FAILURE_MESSAGE)
  /usr/share/cmake-3.22/Modules/FindBZip2.cmake:66 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
  cmake/Modules/FindBzip2_EP.cmake:38 (find_package)
  cmake/TileDB-Superbuild.cmake:102 (include)
  CMakeLists.txt:148 (include)
```

This error also doesn't manifest in Github Actions, because vcpkg is installed in all(?) runners by default ([example run](https://github.com/ryan-williams/tiledb-scratch/actions/runs/8208435007/job/22451855957)).
