from setuptools import setup
from Cython.Build import cythonize
import versioneer
import numpy
import sysconfig
from distutils import ccompiler


LinkCompileArgs = ["/std:c++20"] if (
    sysconfig.get_config_var("CXX") or ccompiler.get_default_compiler()
).split()[0] == "msvc" else ["-std=c++20"]


setup(
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    include_dirs=[numpy.get_include()],
    ext_modules=cythonize(
        f"src/**/*.pyx",
        language_level=3,
        aliases={
            "CPPCARGS": LinkCompileArgs,
            "CPPLARGS": LinkCompileArgs
        }
    ),
)
