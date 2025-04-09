from typing import Union, Mapping

from setuptools import build_meta
from setuptools.build_meta import *


def get_requires_for_build_wheel(
    config_settings: Union[Mapping[str, Union[str, list[str], None]], None] = None,
) -> list[str]:
    requirements = []
    requirements.extend(build_meta.get_requires_for_build_wheel(config_settings))
    requirements.append("wheel")
    requirements.append("pybind11[global]==2.13.6")
    if config_settings and config_settings.get("AMULET_FREEZE_COMPILER"):
        requirements.append(
            "amulet-compiler-version@git+https://github.com/Amulet-Team/Amulet-Compiler-Version.git@1.0"
        )
    return requirements
