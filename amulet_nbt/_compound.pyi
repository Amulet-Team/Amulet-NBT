from typing import Any, Dict
from collections.abc import MutableMapping

from ._value import BaseMutableTag
from ._dtype import AnyNBT

class CompoundTag(BaseMutableTag, MutableMapping[str, AnyNBT]):
    tag_id: int
    def __init__(self, value: Any = (), **kwvals: AnyNBT): ...
    @property
    def py_dict(self) -> Dict[str, AnyNBT]: ...
