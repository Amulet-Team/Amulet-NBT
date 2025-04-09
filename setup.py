import os
import subprocess
import sys
from pathlib import Path

from setuptools import setup, Extension, Command
from setuptools.command.build_ext import build_ext

import versioneer

dependencies = [
    "amulet-compiler-target==1.0",
    "numpy>=1.17,<3.0",
]
setup_args = {}

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

cmdclass: dict[str, type[Command]] = versioneer.get_cmdclass()


class CMakeBuild(cmdclass.get("build_ext", build_ext)):
    def build_extension(self, ext):
        import pybind11

        ext_fullpath = Path.cwd() / self.get_ext_fullpath("")
        src_dir = ext_fullpath.parent.resolve()

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
                f"-Dpybind11_DIR={pybind11.get_cmake_dir().replace(os.sep, '/')}",
                f"-DCMAKE_INSTALL_PREFIX=install",
                f"-DSRC_INSTALL_DIR={src_dir}",
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
    ext_modules=[Extension("amulet_nbt._amulet_nbt", [])],
    install_requires=dependencies,
    **setup_args,
)
