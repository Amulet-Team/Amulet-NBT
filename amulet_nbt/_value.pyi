from typing import Union, Any
from ._dtype import AnyNBT

class BaseTag:
    tag_id: int
    @property
    def py_data(self) -> Any: ...
    def to_snbt(self, indent: Union[int, str] = None) -> str: ...
    def to_nbt(
        self,
        *,
        compressed=True,
        little_endian=False,
        name="",
    ) -> bytes: ...
    def save_to(
        self, filepath_or_buffer=None, *, compressed=True, little_endian=False, name=""
    ) -> bytes: ...
    def __repr__(self) -> str:
        raise NotImplementedError
    def __str__(self) -> str:
        raise NotImplementedError
    def __eq__(self, other) -> bool:
        raise NotImplementedError
    def __reduce__(self):
        raise NotImplementedError
    def copy(self) -> AnyNBT: ...
    def __deepcopy__(self, memo=None):
        raise NotImplementedError
    def __copy__(self):
        raise NotImplementedError

class BaseImmutableTag(BaseTag):
    def __hash__(self) -> int:
        raise NotImplementedError

class BaseMutableTag(BaseTag):
    __hash__: None
