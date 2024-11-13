load("@aspect_bazel_lib//lib:transitions.bzl", "platform_transition_binary")
load(":platforms.bzl", "platforms")

def multi_platform_binaries(name, binary, target_platforms = platforms.all):
    """The multi_platform_binaries macro creates a the binary for each platform.

    Args:
        name: The name of the target.
        binary: The name of the binary to build.
        target_platforms: A list of platforms to build the binary for. Defaults to all 4 platforms (arm64, amd64) x (linux, macos).
    """

    targets = []
    for platform in target_platforms:
        target_name = "{}-{}".format(name, platform.plaid_platform)
        platform_transition_binary(
            name = target_name,
            binary = binary,
            target_platform = platform.target_platform,
        )

        target_label = Label("@{}//{}:{}".format(native.repo_name().rstrip("~"), native.package_name(), target_name))
        targets.append(target_label)

    native.filegroup(
        name = name,
        srcs = targets,
        visibility = ["//visibility:public"],
    )
