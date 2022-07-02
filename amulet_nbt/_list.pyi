from typing import Iterable, overload, List
from collections.abc import MutableSequence

from ._value import AbstractBaseMutableTag
from ._dtype import AnyNBT

AnyNBTT = TypeVar("AnyNBTT", bound=AnyNBT)

class ListTag(AbstractBaseMutableTag, MutableSequence[AnyNBTT]):
    tag_id: int
    list_data_type: int
    @overload
    def __init__(self, value: Iterable[AnyNBTT] = ()) -> None: ...
    @overload
    def __init__(self, value: Iterable[AnyNBTT] = (), list_data_type=1) -> None: ...
    @property
    def py_list(self) -> List[AnyNBTT]: ...
    def copy(self) -> ListTag[AnyNBTT]: ...
