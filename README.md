# thirdparty_repro

A bazel workspace with a nested thirdparty tools repository.

Here `pkg_tar` simulates publishing to S3 (in reality, it's a separate tool that gets the filegroup
passed with a `$(rootpaths ...)` substitution.

Repro:

```bash
# Building from inside thirdparty works:
cd thirdparty
bazel build //tools:tools_tar

# INFO: Analyzed target //tools:tools_tar (1 packages loaded, 2 targets configured).
# INFO: Found 1 target...
# Target //tools:tools_tar up-to-date:
#   bazel-bin/tools/tools_tar.tar
# INFO: Elapsed time: 0.236s, Critical Path: 0.00s
# INFO: 1 process: 1 internal.
# INFO: Build completed successfully, 1 total action

# Building main repo tools works:
cd ..
bazel build //:tools_tar

# INFO: Analyzed target //:tools_tar (119 packages loaded, 16870 targets configured).
# INFO: Found 1 target...
# Target //:tools_tar up-to-date:
#   bazel-bin/tools_tar.tar
# INFO: Elapsed time: 1.976s, Critical Path: 0.91s
# INFO: 3 processes: 2 internal, 1 darwin-sandbox.
# INFO: Build completed successfully, 3 total actions

# Building "mixed" set of tools fails:
bazel build //:all_tools_tar

# ERROR: no such package '@@com_github_go_delve_delve//cmd/dlv': The repository '@@com_github_go_delve_delve' could not be resolved: Repository '@@com_github_go_delve_delve' is not defined
# ERROR: /private/var/tmp/_bazel_odashevskii/83afba2ed9406b504610b7d8461b4b13/external/thirdparty/tools/dlv/BUILD.bazel:3:24: no such package '@@com_github_go_delve_delve//cmd/dlv': The repository '@@com_github_go_delve_delve' could not be resolved: Repository '@@com_github_go_delve_delve' is not defined and referenced by '@@thirdparty//tools/dlv:multi_platform-linux-arm64'
# ERROR: Analysis of target '//:all_tools_tar' failed; build aborted: Analysis failed
# INFO: Elapsed time: 0.161s, Critical Path: 0.00s
# INFO: 1 process: 1 internal.
# ERROR: Build did NOT complete successfully
```
