from typing import (
    overload,
    Tuple,
    Optional,
    Any,
    Union,
    Iterable,
    SupportsBytes,
)
from .numeric import BaseNumericTag

class BaseIntTag(BaseNumericTag, int):
    # type modifications from numeric
    def __abs__(self) -> int:
        raise NotImplementedError
    def __add__(self, x: int) -> int:
        raise NotImplementedError
    def __radd__(self, x: int) -> int:
        raise NotImplementedError
    def __iadd__(self, x: int) -> BaseIntTag:
        raise NotImplementedError
    def __sub__(self, x: int) -> int:
        raise NotImplementedError
    def __rsub__(self, x: int) -> int:
        raise NotImplementedError
    def __isub__(self, x: int) -> BaseIntTag:
        raise NotImplementedError
    def __mul__(self, x: int) -> int:
        raise NotImplementedError
    def __rmul__(self, x: int) -> int:
        raise NotImplementedError
    def __imul__(self, x: int) -> BaseIntTag:
        raise NotImplementedError
    def __floordiv__(self, x: int) -> int:
        raise NotImplementedError
    def __rfloordiv__(self, x: int) -> int:
        raise NotImplementedError
    def __ifloordiv__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __truediv__(self, x: int) -> float:
        raise NotImplementedError
    def __rtruediv__(self, x: int) -> float:
        raise NotImplementedError
    def __itruediv__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __mod__(self, x: int) -> int:
        raise NotImplementedError
    def __rmod__(self, x: int) -> int:
        raise NotImplementedError
    def __imod__(self, other) -> BaseIntTag:
        raise NotImplementedError
    def __divmod__(self, x: int) -> Tuple[int, int]:
        raise NotImplementedError
    def __rdivmod__(self, x: int) -> Tuple[int, int]:
        raise NotImplementedError
    @overload
    def __pow__(self, x: int, mod: Optional[int] = None) -> int:
        raise NotImplementedError
    @overload
    def __pow__(self, x: float, mod: Optional[int] = None) -> float:
        raise NotImplementedError
    def __rpow__(self, x: int, mod: Optional[int] = None) -> Any:
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
    def __and__(self, n: int) -> int:
        raise NotImplementedError
    def __rand__(self, n: int) -> int:
        raise NotImplementedError
    def __or__(self, n: int) -> int:
        raise NotImplementedError
    def __ror__(self, n: int) -> int:
        raise NotImplementedError
    def __xor__(self, n: int) -> int:
        raise NotImplementedError
    def __rxor__(self, n: int) -> int:
        raise NotImplementedError
    def __lshift__(self, n: int) -> int:
        raise NotImplementedError
    def __rlshift__(self, n: int) -> int:
        raise NotImplementedError
    def __rshift__(self, n: int) -> int:
        raise NotImplementedError
    def __rrshift__(self, n: int) -> int:
        raise NotImplementedError
    def __invert__(self) -> int:
        raise NotImplementedError
    def __index__(self) -> int:
        raise NotImplementedError

class TAG_Byte(BaseIntTag): ...
class TAG_Short(BaseIntTag): ...
class TAG_Int(BaseIntTag): ...
class TAG_Long(BaseIntTag): ...
