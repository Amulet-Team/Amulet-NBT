import sys
import os

from setuptools import setup, find_packages, Extension

from Cython.Build import cythonize

import numpy

include_dirs = [numpy.get_include()]

packages = find_packages(include=["amulet_nbt*",])

requirements_fp = open(os.path.join('.', 'requirements.txt'))

depends_on = requirements_fp.readlines()

requirements_fp.close()

extensions = [
    Extension(
        name="amulet_nbt.amulet_cy_nbt",
        sources=["amulet_nbt/amulet_cy_nbt.pyx"]
    )
]

module_version = os.environ.get("AMULET_NBT_VERSION", "0.0.0")
module_version = module_version if module_version else "0.0.0"

setup(
    name="amulet_nbt",
    version=module_version,
    packages=packages,
    include_dirs=include_dirs,
    include_package_data=True,
    install_requires=depends_on,
    ext_modules=cythonize(extensions, language_level=3, annotate=True),
    zip_safe=False
)