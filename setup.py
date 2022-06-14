from setuptools import setup, find_packages
from Cython.Build import cythonize
import versioneer
import numpy

# Note this will error if no pyx files are present
ext = cythonize(
    f"amulet_nbt/**/*.pyx",
    language_level=3,
)

setup(
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    include_dirs=[numpy.get_include()],
    packages=find_packages(),
    ext_modules=ext,
)
