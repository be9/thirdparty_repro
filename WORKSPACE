workspace(name = "thirdparty-repro")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "f4a9314518ca6acfa16cc4ab43b0b8ce1e4ea64b81c38d8a3772883f153346b8",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "2c7545cc914a411e5c15c3d55a0a5ed34fbff62def0e1f0ab6ed14bda222c3cc",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.39.0/bazel-gazelle-v0.39.0.tar.gz"],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("//build/bzl:deps.bzl", "go_dependencies")

go_register_toolchains(version = "1.22.2")

# gazelle:repository_macro build/bzl/deps.bzl%go_dependencies
go_dependencies()

go_rules_dependencies()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

local_repository(
    name = "thirdparty",
    path = "thirdparty",
)
