from setuptools import setup, Extension
import versioneer
import numpy
import sysconfig
from distutils import ccompiler
import sys
import pybind11
import glob

if (sysconfig.get_config_var("CXX") or ccompiler.get_default_compiler()).split()[
    0
] == "msvc":
    CompileArgs = ["/std:c++20"]
else:
    CompileArgs = ["-std=c++20"]

if sys.platform == "darwin":
    CompileArgs.append("-mmacosx-version-min=10.13")


setup(
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    libraries=[
        (
            "amulet_nbt", dict(
            sources=glob.glob("src/amulet_nbt/cpp/**/*.cpp", recursive=True),
            include_dirs=["src/amulet_nbt/include"],
            cflags=CompileArgs,
        ))
    ],
    ext_modules=[
        Extension(
            name="amulet_nbt._nbt",
            sources=glob.glob("src/amulet_nbt/pybind/**/*.cpp", recursive=True),
            include_dirs=["src/amulet_nbt/include", numpy.get_include(), pybind11.get_include()],
            libraries=["amulet_nbt"],
            extra_compile_args=CompileArgs
        )
    ]
)
