import os
import subprocess
import sys
from pathlib import Path

from setuptools import setup, Extension, Command
from setuptools.command.build_ext import build_ext

from packaging.version import Version
import versioneer


def fix_path(path: str) -> str:
    return os.path.realpath(path).replace(os.sep, "/")


dependencies = [
    "amulet-compiler-target==1.0",
    "numpy>=1.17,<3.0",
]
setup_args = {}


def add_cpp_dependency(lib_name: str, version_str: str) -> None:
    version = Version(version_str)
    if version.is_prerelease:
        # Breaking API changes can be made between pre-release versions. Pin to this exact release.
        dependencies.append(f"{lib_name}=={version_str}")
    else:
        # Major - breaking API change. Dependents must be updated and recompiled.
        major = version.major
        # Minor - backwards compatible API change. Dependents must be recompiled.
        minor = version.minor
        # Patch - API unchanged. Dependents must be recompiled.
        patch = version.micro
        # Fix - API unchanged. Dependents do not need to be recompiled.
        dependencies.append(f"{lib_name}~={major}.{minor}.{patch}.0")


try:
    import amulet_compiler_version
except ImportError:
    dependencies.append("amulet-compiler-version==1.3.0")
else:
    dependencies.append(
        f"amulet-compiler-version=={amulet_compiler_version.__version__}"
    )
    setup_args["options"] = {
        "bdist_wheel": {
            "build_number": f"1.{amulet_compiler_version.compiler_id}.{amulet_compiler_version.compiler_version}"
        }
    }

try:
    import amulet.io
except ImportError:
    dependencies.append("amulet_io~=1.0")
else:
    add_cpp_dependency("amulet_io", amulet.io.__version__)


cmdclass: dict[str, type[Command]] = versioneer.get_cmdclass()


class CMakeBuild(cmdclass.get("build_ext", build_ext)):
    def build_extension(self, ext):
        import pybind11
        import amulet.io
        import amulet.pybind11_extensions

        ext_dir = (
                (Path.cwd() / self.get_ext_fullpath("")).parent.resolve()
                / "amulet"
                / "nbt"
        )
        nbt_src_dir = (
            Path.cwd() / "src" / "amulet" / "nbt" if self.editable_mode else ext_dir
        )

        platform_args = []
        if sys.platform == "win32":
            platform_args.extend(["-G", "Visual Studio 17 2022"])
            if sys.maxsize > 2**32:
                platform_args.extend(["-A", "x64"])
            else:
                platform_args.extend(["-A", "Win32"])
            platform_args.extend(["-T", "v143"])

        if subprocess.run(
            [
                "cmake",
                *platform_args,
                f"-DPYTHON_EXECUTABLE={sys.executable}",
                f"-Dpybind11_DIR={fix_path(pybind11.get_cmake_dir())}",
                f"-Damulet_pybind11_extensions_DIR={(amulet.pybind11_extensions.__path__[0])}",
                f"-Damulet_io_DIR={fix_path(amulet.io.__path__[0])}",
                f"-Damulet_nbt_DIR={fix_path(nbt_src_dir)}",
                f"-DAMULET_NBT_EXT_DIR={fix_path(ext_dir)}",
                f"-DCMAKE_INSTALL_PREFIX=install",
                "-B",
                "build",
            ]
        ).returncode:
            raise RuntimeError("Error configuring amulet_nbt")
        if subprocess.run(
            ["cmake", "--build", "build", "--config", "Release"]
        ).returncode:
            raise RuntimeError("Error installing amulet_nbt")
        if subprocess.run(
            ["cmake", "--install", "build", "--config", "Release"]
        ).returncode:
            raise RuntimeError("Error installing amulet_nbt")


cmdclass["build_ext"] = CMakeBuild


setup(
    version=versioneer.get_version(),
    cmdclass=cmdclass,
    ext_modules=[Extension("amulet.nbt._amulet_nbt", [])],
    install_requires=dependencies,
    **setup_args,
)
