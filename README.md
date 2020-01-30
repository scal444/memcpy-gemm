# memcpy-gemm

memcpy-gemm provides libraries and binaries for testing the communication
and compute performance of GPUs. The primary binary generated for this purpose
is the memcpy_gemm program. memcpy_gemm supports testing communication speed
between any GPU and it's host or peers, and can test the compute
performance in half, single, or double precision for matrix multiplication.

## Requirements:
memcpy-gemm requires the following tools for installation
* bazel
* autoconf

Bazel relies on the following libraries for execution. When building, bazel
will pull the versions specified in the WORKSPACE file from internet sources.
* abseil
* glog
* googletest
* libnuma
* half
* re2

Currently, libnuma depends on autoconf for configuration, which we wrap in bazel
at build time.

memcpy-gemm also requires a CUDA installation. The default location is
/usr/local/cuda. To specify a different directory, export a "CUDA_PATH"
environmental variable. Note that bazel will create a symlink to this path
as "cuda", which is how cuda headers are referenced in the code.

## Building:
With the proper dependencies installed, building the memcpy_gemm binary
should be as simple as:

`bazel build :memcpy_gemm`

and the memcpy_gemm binary is built in to bazel-bin

To run tests, "bazel test :memcpy_gemm_test" or "bazel test :all". Note that
the memcpy_gemm_test assumes that one GPU is available, but makes no assumptions
about its performance characteristics.

## Creating a static build:
By default, when built on most linux systems memcpy-gemm dynamically links to
libgcc, libstdc++, and libc. While some dynamic dependencies to libc are unavoidable,
memcpy-gemm will link statically to libstdc++ and libgcc if compiled in the static configuration:

`bazel build --config=static :memcpy_gemm`

This mode is useful for sidestepping dependencies when building for cross-compilation.

### Troubleshooting static build
memcpy-gemm uses it's own description of the C++ toolchain for static builds. On some linux systems,
the toolchain include paths may be incorrectly configured. When building in static mode, this can
lead to errors such as:

> this rule is missing dependency declarations for the following files included by (some library)
> '/usr/lib/....some header'
> '/usr/lib/....other header'

In the short term, this issue can be fixed by modifying the C++ toolchain descriptor file.
Open /(path/to/memcpy-gemm/source)/toolchain/cc_toolchain_config.bzl. Search for the
cxx_bultin_include_directories variable, and add the path to your headers to the list.

## Running:
To see the list of options of memcpy-gemm, type "/path/to/memcpy_gemm --help".