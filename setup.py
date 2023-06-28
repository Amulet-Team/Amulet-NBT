from setuptools import setup
from Cython.Build import cythonize
import versioneer
import numpy

setup(
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    include_dirs=[numpy.get_include()],
    ext_modules=cythonize(f"src/**/*.pyx", language_level=3),
)
