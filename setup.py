import sys
import os

from setuptools import setup, find_packages, Extension

from Cython.Build import cythonize

import numpy

include_dirs = [numpy.get_include()]

sys.path.append((os.path.join(os.path.dirname(__file__), "src")))

packages = find_packages("src")

requirements_fp = open(os.path.join('.', 'requirements.txt'))

depends_on = requirements_fp.readlines()

requirements_fp.close()

extensions = [
    Extension(
        name="amulet_nbt.amulet_cy_nbt",
        sources=["src/amulet_nbt/amulet_cy_nbt.pyx"]
    )
]

setup(
    name="amulet_nbt",
    version=os.environ.get("AMULET_NBT_VERSION", "0.0.0"),
    packages=packages,
    package_dir={"": "src"},
    include_dirs=include_dirs,
    include_package_data=True,
    install_requires=depends_on,
    ext_modules=cythonize(extensions, language_level=3, annotate=True),
    zip_safe=False
)