from __future__ import annotations

import amulet.nbt

__all__: list[str] = ["encode_binary_nbt"]

def encode_binary_nbt(tag: amulet.nbt.NamedTag) -> bytes: ...
