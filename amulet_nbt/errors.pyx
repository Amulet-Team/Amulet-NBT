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
    pass
