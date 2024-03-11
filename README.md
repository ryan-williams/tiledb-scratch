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
