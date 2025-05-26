import os
from contextlib import suppress
from packaging.version import Version

PYBIND11_REQUIREMENT = "==2.13.6"
AMULET_COMPILER_TARGET_REQUIREMENT = "==1.0"
AMULET_COMPILER_VERSION_REQUIREMENT = "==3.0.0"
AMULET_PYBIND11_EXTENSIONS_REQUIREMENT = "~=1.0"
AMULET_IO_REQUIREMENT = "~=1.0"
NUMPY_REQUIREMENT = "~=2.0"


def get_build_dependencies() -> list:
    deps = [
        f"pybind11{PYBIND11_REQUIREMENT}",
        f"amulet_pybind11_extensions{AMULET_PYBIND11_EXTENSIONS_REQUIREMENT}",
        f"amulet_io{AMULET_IO_REQUIREMENT}",
        "amulet-compiler-version@git+https://github.com/Amulet-Team/Amulet-Compiler-Version.git@1.0"
    ]
    return deps


def _get_specifier_set(version_str: str, compiler_suffix: str = "") -> str:
    """
    version_str: The PEP 440 version number of the library.
    compiler_suffix: Only specified if it is a compiled library and the compiler is being frozen.
    """
    version = Version(version_str)
    if version.epoch != 0 or version.is_devrelease or version.is_postrelease:
        raise RuntimeError(f"Unsupported version format. {version_str}")

    major, minor, patch, fix, *_ = version.release + (0, 0, 0, 0)

    if version.is_prerelease:
        # Pre-releases can make breaking changes. Pin to this exact release.
        if compiler_suffix:
            return f"=={major}.{minor}.{patch}.{fix}{compiler_suffix}{''.join(map(str, version.pre))}"
        else:
            return f"=={version_str}"
    else:
        # Require an ABI compatible build.
        return f"~={major}.{minor}.{patch}.{fix}"


def get_runtime_dependencies() -> list[str]:
    compiler_suffix = ""
    amulet_compiler_version_requirement = f"amulet-compiler-version{AMULET_COMPILER_VERSION_REQUIREMENT}"

    if os.environ.get("AMULET_FREEZE_COMPILER", None):
        with suppress(ImportError):
            import amulet_compiler_version
            amulet_compiler_version_requirement = f"amulet-compiler-version=={amulet_compiler_version.__version__}"
            compiler_suffix = f".{'.'.join(amulet_compiler_version.__version__.split('.')[3:])}"

    try:
        import amulet.io
    except ImportError:
        amulet_io_requirement = f"amulet-io{AMULET_IO_REQUIREMENT}"
    else:
        amulet_io_requirement = f"amulet-io{_get_specifier_set(amulet.io.__version__)}"

    return [
        f"amulet-compiler-target{AMULET_COMPILER_TARGET_REQUIREMENT}",
        f"numpy{NUMPY_REQUIREMENT}",
        amulet_compiler_version_requirement,
        amulet_io_requirement,
    ]
