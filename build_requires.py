from typing import Union, Mapping
import os

from setuptools import build_meta
from setuptools.build_meta import *


_extension_requirements = [
    "pybind11[global]==2.13.6",
    "amulet_io~=1.0",
    "amulet_pybind11_extensions~=1.0",
]


def get_requires_for_build_wheel(
    config_settings: Union[Mapping[str, Union[str, list[str], None]], None] = None,
) -> list[str]:
    requirements = []
    requirements.extend(build_meta.get_requires_for_build_wheel(config_settings))
    requirements.append("wheel")
    requirements.extend(_extension_requirements)
    if (
        config_settings and config_settings.get("AMULET_FREEZE_COMPILER")
    ) or os.environ.get("AMULET_FREEZE_COMPILER", None):
        requirements.append(
            "amulet-compiler-version@git+https://github.com/Amulet-Team/Amulet-Compiler-Version.git@1.0"
        )
    return requirements


def get_requires_for_build_editable(
    config_settings: Union[Mapping[str, Union[str, list[str], None]], None] = None,
) -> list[str]:
    return (
        build_meta.get_requires_for_build_editable(config_settings)
        + _extension_requirements
    )
