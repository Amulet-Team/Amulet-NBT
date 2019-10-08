try:
    from .amulet_cy_nbt import *
except (ImportError, ModuleNotFoundError) as e:
    from .amulet_py_nbt import *
