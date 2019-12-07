import os

from setuptools import setup, find_packages, Extension

CYTHON_COMPILE = False
try:
    from Cython.Build import cythonize

    CYTHON_COMPILE = True
except Exception:
    pass

import numpy

include_dirs = [numpy.get_include()]

packages = find_packages(include=["amulet_nbt*",])

requirements_fp = open(os.path.join('.', 'requirements.txt'))

depends_on = [line.strip() for line in requirements_fp.readlines()]

requirements_fp.close()

extensions = [
    Extension(
        name="amulet_nbt.amulet_cy_nbt",
        sources=["amulet_nbt/amulet_cy_nbt.pyx"]
    )
]

module_version = os.environ.get("AMULET_NBT_VERSION", "0.0.0")
module_version = module_version if module_version else "0.0.0"

SETUP_PARAMS = {
    'name': "amulet-nbt",
    'version': module_version,
    'packages': packages,
    'include_dirs': include_dirs,
    'include_package_data': True,
    'install_requires': depends_on,
    'setup_requires': depends_on,
    'zip_safe': False
}

if CYTHON_COMPILE:
    SETUP_PARAMS["ext_modules"] = cythonize(extensions, language_level=3, annotate=True)

setup(**SETUP_PARAMS)