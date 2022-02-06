import pkgutil

import amulet_nbt

hiddenimports = [
    name
    for _, name, _ in pkgutil.walk_packages(
        amulet_nbt.__path__, amulet_nbt.__name__ + "."
    )
]
