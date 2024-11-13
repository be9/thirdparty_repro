"""Reusable platforms for Bazel rules."""

_OS_MAPPING = struct(
    MACOS = "macos",
    LINUX = "linux",
)

_PLAID_OS_MAPPING = {
    _OS_MAPPING.MACOS: "darwin",
    _OS_MAPPING.LINUX: "linux",
}

_ARCH_MAPPING = struct(
    AMD64 = "x86_64",
    ARM64 = "aarch64",
)

_PLAID_ARCH_MAPPING = {
    _ARCH_MAPPING.AMD64: "amd64",
    _ARCH_MAPPING.ARM64: "arm64",
}

def _new(os, arch):
    """Create a platform `struct`.

    Args:
        os: A `string` value from `platforms.os`.
        arch: A `string` value from `platforms.arch`.

    Returns:
        A `struct` representing a release platform.
    """
    return struct(
        os = os,
        arch = arch,
        plaid_platform = "{}-{}".format(_PLAID_OS_MAPPING[os], _PLAID_ARCH_MAPPING[arch]),
        # The target platform for the transition rules
        target_platform = "@aspect_bazel_lib//platforms:{}_{}".format(os, arch),
    )

_PLATFORMS = [
    _new(os = _OS_MAPPING.MACOS, arch = _ARCH_MAPPING.AMD64),
    _new(os = _OS_MAPPING.MACOS, arch = _ARCH_MAPPING.ARM64),
    _new(os = _OS_MAPPING.LINUX, arch = _ARCH_MAPPING.AMD64),
    _new(os = _OS_MAPPING.LINUX, arch = _ARCH_MAPPING.ARM64),
]

platforms = struct(
    all = _PLATFORMS,
    arch = _ARCH_MAPPING,
    os = _OS_MAPPING,
)
