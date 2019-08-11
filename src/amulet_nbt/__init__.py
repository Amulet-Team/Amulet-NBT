import traceback

try:
    from .amulet_cy_nbt import *
    print("Using Amulet NBT library")
except ImportError as e:
    traceback.print_exc()
    from .amulet_py_nbt import *
    print("Using pure python NBT library")