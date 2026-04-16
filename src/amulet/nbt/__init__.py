from __future__ import annotations
from typing import TYPE_CHECKING
import logging as _logging
import re

from . import _version

__version__ = _version.get_versions()["version"]

# init a default logger
_logging.basicConfig(level=_logging.INFO, format="%(levelname)s - %(message)s")


def _init() -> None:
    import os
    import sys
    import ctypes

    if os.environ.get("AMULET_SKIP_COMPILE", None):
        return

    if sys.platform == "win32":
        lib_path = os.path.join(os.path.dirname(__file__), "amulet_nbt.dll")
    elif sys.platform == "darwin":
        lib_path = os.path.join(os.path.dirname(__file__), "libamulet_nbt.dylib")
    elif sys.platform == "linux":
        lib_path = os.path.join(os.path.dirname(__file__), "libamulet_nbt.so")
    else:
        raise RuntimeError(f"Unsupported platform {sys.platform}")

    # Import dependencies
    import amulet.zlib

    # Load the shared library
    ctypes.cdll.LoadLibrary(lib_path)

    from ._amulet_nbt import init

    init(sys.modules[__name__])


_init()


SNBTType: TypeAlias = str
IntType: TypeAlias = ByteTag | ShortTag | IntTag | LongTag
FloatType: TypeAlias = FloatTag | DoubleTag
NumberType: TypeAlias = IntType | FloatType
ArrayType: TypeAlias = ByteArrayTag | IntArrayTag | LongArrayTag

AnyNBT: TypeAlias = NumberType | StringTag | ListTag | CompoundTag | ArrayType
