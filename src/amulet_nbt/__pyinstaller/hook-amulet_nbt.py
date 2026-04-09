import pkgutil

import amulet_nbt

hiddenimports = ["mutf8"] + [
    name
    for _, name, _ in pkgutil.walk_packages(
        amulet_nbt.__path__, amulet_nbt.__name__ + "."
    )
]
