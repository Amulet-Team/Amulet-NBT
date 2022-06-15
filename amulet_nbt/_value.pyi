from typing import Union, Any
from ._dtype import AnyNBT, EncoderType
from ._util import utf8_encoder

class AbstractBase:
    def to_snbt(self, indent: Union[int, str] = None) -> str: ...
    def to_nbt(
        self,
        *,
        compressed=True,
        little_endian=False,
        name="",
        string_encoder: EncoderType = utf8_encoder,
    ) -> bytes: ...
    def save_to(
        self,
        filepath_or_buffer=None,
        *,
        compressed=True,
        little_endian=False,
        name="",
        string_encoder: EncoderType = utf8_encoder,
    ) -> bytes: ...

class AbstractBaseTag(AbstractBase):
    tag_id: int
    @property
    def py_data(self) -> Any: ...
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

class AbstractBaseImmutableTag(AbstractBaseTag):
    def __hash__(self) -> int:
        raise NotImplementedError

class AbstractBaseMutableTag(AbstractBaseTag):
    __hash__: None
