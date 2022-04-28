from typing import Iterable, overload, List
from collections.abc import MutableSequence

from ._value import BaseMutableTag
from ._dtype import AnyNBT

class ListTag(BaseMutableTag, MutableSequence[AnyNBT]):
    tag_id: int
    list_data_type: int
    @overload
    def __init__(self, value: Iterable[AnyNBT] = ()) -> None: ...
    @overload
    def __init__(self, value: Iterable[AnyNBT] = (), list_data_type=1) -> None: ...
    @property
    def py_list(self) -> List[AnyNBT]: ...
    def copy(self) -> List[AnyNBT]: ...
