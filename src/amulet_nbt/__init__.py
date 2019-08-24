import traceback

try:
    from .amulet_cy_nbt import *
    if __debug__:
        print("Using Amulet NBT library")
except (ImportError, ModuleNotFoundError) as e:
    from .amulet_py_nbt import *
    if __debug__:
        traceback.print_exc()
        print("Using pure python NBT library")