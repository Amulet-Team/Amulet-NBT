from typing import Optional

class NBTError(Exception):
    """Some error in the NBT library."""


class NBTLoadError(NBTError):
    """The NBT data failed to load for some reason."""
    pass


class NBTFormatError(NBTLoadError):
    """Indicates the NBT format is invalid."""
    pass


class SNBTParseError(NBTError):
    """Indicates the SNBT format is invalid."""

    index: Optional[int]  # The index at which the error occurred

    def __init__(self, *args, index=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.index = index
