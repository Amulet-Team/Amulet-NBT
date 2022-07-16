from setuptools import setup
import sys
import os
import versioneer
cmdclass=versioneer.get_cmdclass()

sys.path.append(os.path.join(os.path.dirname(__file__), "build_tools"))

# build tools import
import cythonise
cythonise.register(cmdclass)

setup(
    version=versioneer.get_version(),
    cmdclass=cmdclass,
)
