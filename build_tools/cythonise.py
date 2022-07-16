import os
from typing import Dict, Type
import glob

from setuptools import Command
from setuptools.command.build import build as build_

from Cython.Build import cythonize


def register(cmdclass: Dict[str, Type[Command]]):
    # register a new command class
    cmdclass["cythonise"] = Cythonise
    # get the build command class
    build = cmdclass.get("build", build_)
    # register our command class as a subcommand of the build command class
    build.sub_commands.append(("cythonise", None))


class Cythonise(Command):
    def initialize_options(self):
        self.build_lib = None

    def finalize_options(self):
        self.set_undefined_options("build_py", ("build_lib", "build_lib"))

    def run(self):
        print("cythonising")
        pyx_path = os.path.join(self.build_lib, "amulet_nbt", "**", "*.pyx")
        if next(glob.iglob(pyx_path, recursive=True), None):
            # This throws an error if it does not match any files
            self.distribution.ext_modules = (
                self.distribution.ext_modules
                or []
                + cythonize(
                    pyx_path,
                    language_level=3,
                )
            )
        try:
            import numpy
        except ImportError:
            pass
        else:
            self.distribution.include_dirs = self.distribution.include_dirs or [] + [
                numpy.get_include()
            ]
