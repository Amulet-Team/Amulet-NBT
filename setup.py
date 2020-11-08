import os
import glob
import shutil
from setuptools import setup, find_packages, Extension
import numpy
import versioneer

CYTHON_COMPILE = False
try:
    from Cython.Build import cythonize

    CYTHON_COMPILE = True
except Exception:
    pass

# there were issues with other builds carrying over their cache
for d in glob.glob("*.egg-info"):
    shutil.rmtree(d)

with open(os.path.join('.', 'requirements.txt')) as requirements_fp:
    depends_on = [line.strip() for line in requirements_fp.readlines()]

if CYTHON_COMPILE:
    extensions = [
        Extension(
            name="amulet_nbt.amulet_cy_nbt",
            sources=["amulet_nbt/amulet_cy_nbt.pyx"]
        )
    ]
    ext_modules = cythonize(extensions, language_level=3, annotate=True)
else:
    ext_modules = []

setup(
    name="amulet-nbt",
    version=versioneer.get_version(),
    description="Read and write Minecraft NBT and SNBT data.",
    author="Ben Gothard, James Clare",
    author_email="amuleteditor@gmail.com",
    install_requires=depends_on,
    setup_requires=depends_on,
    packages=find_packages(),
    ext_modules=ext_modules,
    include_dirs=[numpy.get_include()],
    include_package_data=True,
    cmdclass=versioneer.get_cmdclass(),
    zip_safe=False
)
