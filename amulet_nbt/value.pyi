from typing import Union, List
from .dtype import AnyNBT

class BaseTag:
    tag_id: int
    @property
    def value(self):
        raise NotImplementedError
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
    def __dir__(self) -> List[str]:
        raise NotImplementedError
    def __eq__(self, other) -> bool:
        raise NotImplementedError
    def strict_equals(self, other) -> bool: ...
    def __ge__(self, other) -> bool:
        raise NotImplementedError
    def __gt__(self, other) -> bool:
        raise NotImplementedError
    def __le__(self, other) -> bool:
        raise NotImplementedError
    def __lt__(self, other) -> bool:
        raise NotImplementedError
    def __reduce__(self):
        raise NotImplementedError
    def copy(self) -> AnyNBT: ...
    def __deepcopy__(self, memo=None):
        raise NotImplementedError
    def __copy__(self):
        raise NotImplementedError
    def __hash__(self):
        raise NotImplementedError

class BaseImmutableTag(BaseTag):
    def __hash__(self) -> int:
        raise NotImplementedError

class BaseMutableTag(BaseTag):
    __hash__: None
