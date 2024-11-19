# thirdparty_repro

A bazel workspace with a nested thirdparty tools repository.

Here `pkg_tar` simulates publishing to S3 (in reality, it's a separate tool that gets the filegroup
passed with a `$(rootpaths ...)` substitution.

## Go static linking problem

Build/load the image:

```bash
bazel run //:image_tarball
# INFO: Analyzed target //:image_tarball (0 packages loaded, 0 targets configured).
# INFO: Found 1 target...
# Target //:image_tarball up-to-date:
#   bazel-bin/image_tarball.sh
# INFO: Elapsed time: 0.132s, Critical Path: 0.00s
# INFO: 1 process: 1 internal.
# INFO: Build completed successfully, 1 total action
# INFO: Running command line: bazel-bin/image_tarball.sh
# Loaded image: 3p_repro:latest
```

The binary that originates from the main repo is statically linked:
```bash
docker run -it --rm 3p_repro:latest app/tools/one/multi_platform-linux-amd64/one
# delve is version.Version{Major:"1", Minor:"20", Patch:"0", Metadata:"", Build:"$Id: 8ec46ee3d275c276b8e7465d69a23399e0e14789 $"}
# reverse of 'foo' is 'oof'

docker run -it --rm 3p_repro:latest ldd app/tools/one/multi_platform-linux-amd64/one
# /lib/ld-musl-x86_64.so.1: app/tools/one/multi_platform-linux-amd64/one: Not a valid dynamic program
```

The `dlv` that comes from `@thirdparty` is linked dynamically:
```bash
docker run -it --rm 3p_repro:latest  /app/external/thirdparty\~/tools/dlv/multi_platform-linux-amd64/dlv
# exec /app/external/thirdparty~/tools/dlv/multi_platform-linux-amd64/dlv: no such file or directory

docker run -it --rm 3p_repro:latest ldd /app/external/thirdparty\~/tools/dlv/multi_platform-linux-amd64/dlv
#         /lib64/ld-linux-x86-64.so.2 (0x7a3dfd261000)
# Error loading shared library libresolv.so.2: No such file or directory (needed by /app/external/thirdparty~/tools/dlv/multi_platform-linux-amd64/dlv)
#         libc.so.6 => /lib64/ld-linux-x86-64.so.2 (0x7a3dfd261000)
```

## grpc-gateway problem (ignored for now)

```bash
# Building from inside thirdparty works:
cd thirdparty
bazel build //tools:tools_tar

# INFO: Analyzed target //tools:tools_tar (313 packages loaded, 24891 targets configured).
# INFO: Found 1 target...
# Target //tools:tools_tar up-to-date:
#   bazel-bin/tools/tools_tar.tar
# INFO: Elapsed time: 17.778s, Critical Path: 8.78s
# INFO: 95 processes: 6 internal, 89 darwin-sandbox.
# INFO: Build completed successfully, 95 total actions

# Building main repo tools works:
cd ..
bazel build //:tools_tar

# INFO: Analyzed target //:tools_tar (72 packages loaded, 23423 targets configured).
# INFO: Found 1 target...
# Target //:tools_tar up-to-date:
#   bazel-bin/tools_tar.tar
# INFO: Elapsed time: 4.506s, Critical Path: 2.57s
# INFO: 14 processes: 5 internal, 9 darwin-sandbox.
# INFO: Build completed successfully, 14 total actions

# Building "mixed" set of tools fails:
bazel build //:all_tools_tar

# WARNING: For repository 'aspect_bazel_lib', the root module requires module version aspect_bazel_lib@2.9.0, but got aspect_bazel_lib@2.9.3 in the resolved dependency graph.
# ERROR: /private/var/tmp/_bazel_odashevskii/83afba2ed9406b504610b7d8461b4b13/external/gazelle~/internal/bzlmod/go_deps.bzl:100:13: Traceback (most recent call last):
# 	File "/private/var/tmp/_bazel_odashevskii/83afba2ed9406b504610b7d8461b4b13/external/gazelle~/internal/bzlmod/go_deps.bzl", line 380, column 27, in _go_deps_impl
# 		_process_overrides(module_ctx, module, "gazelle_override", gazelle_overrides, _process_gazelle_override)
# 	File "/private/var/tmp/_bazel_odashevskii/83afba2ed9406b504610b7d8461b4b13/external/gazelle~/internal/bzlmod/go_deps.bzl", line 214, column 32, in _process_overrides
# 		_fail_on_non_root_overrides(module_ctx, module, override_type)
# 	File "/private/var/tmp/_bazel_odashevskii/83afba2ed9406b504610b7d8461b4b13/external/gazelle~/internal/bzlmod/go_deps.bzl", line 100, column 13, in _fail_on_non_root_overrides
# 		fail(_FORBIDDEN_OVERRIDE_TAG.format(
# Error in fail: Using the "go_deps.gazelle_override" tag in a non-root Bazel module is forbidden, but module "thirdparty" requests it.
#
# If you need this override for a Bazel module that will be available in a public registry (such as the Bazel Central Registry), please file an issue at https://github.com/bazelbuild/bazel-gazelle/issues/new or submit a PR adding the required directives to the "default_gazelle_overrides.bzl" file at https://github.com/bazelbuild/bazel-gazelle/tree/master/internal/bzlmod/default_gazelle_overrides.bzl.
# ERROR: Analysis of target '//:all_tools_tar' failed; build aborted: error evaluating module extension go_deps in @@gazelle~//:extensions.bzl
# INFO: Elapsed time: 0.591s, Critical Path: 0.00s
# INFO: 1 process: 1 internal.
# ERROR: Build did NOT complete successfully
# FAILED:
#     Fetching module extension go_deps in @@gazelle~//:extensions.bzl; starting
#     Fetching repository @@rules_java~~toolchains~local_jdk; starting
#     Fetching repository @@rules_java~~toolchains~remotejdk11_linux_toolchain_config_repo; starting
```
