from typing import (
    overload,
    Tuple,
    Optional,
    Any,
    Union,
    Iterable,
    SupportsBytes,
)
from ._numeric import BaseNumericTag
from ._float import BaseFloatTag
from ._string import StringTag

Num = Union[int, float, BaseNumericTag]
Int = Union[int, "BaseIntTag"]
Float = Union[float, BaseFloatTag]
Str = Union[str, StringTag]

class BaseIntTag(BaseNumericTag):
    # type modifications from numeric
    def __abs__(self) -> int:
        raise NotImplementedError
    @overload
    def __add__(self, x: Int) -> int:
        raise NotImplementedError
    @overload
    def __add__(self, x: Float) -> float:
        raise NotImplementedError
    @overload
    def __radd__(self, x: Int) -> int:
        raise NotImplementedError
    @overload
    def __radd__(self, x: Float) -> float:
        raise NotImplementedError
    def __iadd__(self, x: Num) -> BaseIntTag:
        raise NotImplementedError
    @overload
    def __sub__(self, x: Int) -> int:
        raise NotImplementedError
    @overload
    def __sub__(self, x: Float) -> float:
        raise NotImplementedError
    @overload
    def __rsub__(self, x: Int) -> int:
        raise NotImplementedError
    @overload
    def __rsub__(self, x: Float) -> float:
        raise NotImplementedError
    def __isub__(self, x: Num) -> BaseIntTag:
        raise NotImplementedError
    @overload
    def __mul__(self, x: Int) -> int:
        raise NotImplementedError
    @overload
    def __mul__(self, x: Float) -> float:
        raise NotImplementedError
    @overload
    def __mul__(self, x: Str) -> str:
        raise NotImplementedError
    @overload
    def __rmul__(self, x: Int) -> int:
        raise NotImplementedError
    @overload
    def __rmul__(self, x: Float) -> float:
        raise NotImplementedError
    @overload
    def __rmul__(self, x: Str) -> str:
        raise NotImplementedError
    @overload
    def __imul__(self, x: Num) -> BaseIntTag:
        raise NotImplementedError
    @overload
    def __imul__(self, x: Str) -> str:
        raise NotImplementedError
    def __floordiv__(self, x: Int) -> int:
        raise NotImplementedError
    def __rfloordiv__(self, x: Int) -> int:
        raise NotImplementedError
    def __ifloordiv__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __truediv__(self, x: Int) -> float:
        raise NotImplementedError
    def __rtruediv__(self, x: Int) -> float:
        raise NotImplementedError
    def __itruediv__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __mod__(self, x: Int) -> int:
        raise NotImplementedError
    def __rmod__(self, x: Int) -> int:
        raise NotImplementedError
    def __imod__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __divmod__(self, x: Int) -> Tuple[int, int]:
        raise NotImplementedError
    def __rdivmod__(self, x: Int) -> Tuple[int, int]:
        raise NotImplementedError
    @overload
    def __pow__(self, x: Int, mod: Optional[int] = None) -> int:
        raise NotImplementedError
    @overload
    def __pow__(self, x: float, mod: Optional[int] = None) -> float:
        raise NotImplementedError
    def __rpow__(self, x: Int, mod: Optional[int] = None) -> Any:
        raise NotImplementedError
    def __ipow__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __neg__(self) -> int:
        raise NotImplementedError
    def __pos__(self) -> int:
        raise NotImplementedError
    def __round__(self, ndigits: Optional[int] = ...) -> int:
        raise NotImplementedError
    # not in numeric
    @classmethod
    def from_bytes(
        cls,
        bytes: Union[Iterable[int], SupportsBytes],
        byteorder: str,
        *,
        signed: bool = False
    ) -> BaseIntTag:
        raise NotImplementedError
    def __and__(self, n: Int) -> int:
        raise NotImplementedError
    def __rand__(self, n: Int) -> int:
        raise NotImplementedError
    def __or__(self, n: Int) -> int:
        raise NotImplementedError
    def __ror__(self, n: Int) -> int:
        raise NotImplementedError
    def __xor__(self, n: Int) -> int:
        raise NotImplementedError
    def __rxor__(self, n: Int) -> int:
        raise NotImplementedError
    def __lshift__(self, n: Int) -> int:
        raise NotImplementedError
    def __rlshift__(self, n: Int) -> int:
        raise NotImplementedError
    def __rshift__(self, n: Int) -> int:
        raise NotImplementedError
    def __rrshift__(self, n: Int) -> int:
        raise NotImplementedError
    def __invert__(self) -> int:
        raise NotImplementedError
    def __index__(self) -> int:
        raise NotImplementedError

class ByteTag(BaseIntTag): ...
class ShortTag(BaseIntTag): ...
class IntTag(BaseIntTag): ...
class LongTag(BaseIntTag): ...
