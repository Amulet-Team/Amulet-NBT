import logging as _logging

from . import _version

__version__ = _version.get_versions()["version"]

# init a default logger
_logging.basicConfig(level=_logging.INFO, format="%(levelname)s - %(message)s")


def _init() -> None:
    import os
    import sys

    if os.environ.get("AMULET_SKIP_COMPILE", None):
        return

    # Import dependencies
    import amulet.zlib

    from ._amulet_nbt import init

    init(sys.modules[__name__])


_init()
del _init


SNBTType: TypeAlias = str
IntType: TypeAlias = ByteTag | ShortTag | IntTag | LongTag
FloatType: TypeAlias = FloatTag | DoubleTag
NumberType: TypeAlias = IntType | FloatType
ArrayType: TypeAlias = ByteArrayTag | IntArrayTag | LongArrayTag

AnyNBT: TypeAlias = NumberType | StringTag | ListTag | CompoundTag | ArrayType
