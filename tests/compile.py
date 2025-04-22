import subprocess
import sys
import shutil
import os

import pybind11
import pybind11_extensions

import amulet.io
import amulet.nbt


def fix_path(path: str) -> str:
    return os.path.realpath(path).replace(os.sep, "/")


def main():
    os.chdir(os.path.dirname(__file__))

    if os.path.isdir("build/CMakeFiles"):
        shutil.rmtree("build/CMakeFiles")

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
            f"-Dpybind11_extensions_DIR={(pybind11_extensions.__path__[0])}",
            f"-Damulet_io_DIR={fix_path(amulet.io.__path__[0])}",
            f"-Damulet_nbt_DIR={fix_path(amulet.nbt.__path__[0])}",
            f"-DCMAKE_INSTALL_PREFIX={fix_path(os.path.join(os.path.dirname(__file__), 'test_amulet_nbt'))}",
            "-B",
            "build",
        ]
    ).returncode:
        raise RuntimeError("Error configuring test_amulet_nbt")
    if subprocess.run(
        ["cmake", "--build", "build", "--config", "RelWithDebInfo"]
    ).returncode:
        raise RuntimeError("Error installing test_amulet_nbt")
    if subprocess.run(
        ["cmake", "--install", "build", "--config", "RelWithDebInfo"]
    ).returncode:
        raise RuntimeError("Error installing test_amulet_nbt")


if __name__ == "__main__":
    main()
