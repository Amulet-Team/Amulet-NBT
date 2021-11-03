from typing import overload, Tuple

from .numeric import BaseNumericTag

class BaseFloatTag(BaseNumericTag, float):
    # type modifications from numeric
    def __add__(self, x: float) -> float:
        raise NotImplementedError
    def __radd__(self, x: float) -> float:
        raise NotImplementedError
    def __sub__(self, x: float) -> float:
        raise NotImplementedError
    def __rsub__(self, x: float) -> float:
        raise NotImplementedError
    def __mul__(self, x: float) -> float:
        raise NotImplementedError
    def __rmul__(self, x: float) -> float:
        raise NotImplementedError
    def __floordiv__(self, x: float) -> float:
        raise NotImplementedError
    def __rfloordiv__(self, x: float) -> float:
        raise NotImplementedError
    def __truediv__(self, x: float) -> float:
        raise NotImplementedError
    def __rtruediv__(self, x: float) -> float:
        raise NotImplementedError
    def __mod__(self, x: float) -> float:
        raise NotImplementedError
    def __rmod__(self, x: float) -> float:
        raise NotImplementedError
    def __divmod__(self, x: float) -> Tuple[float, float]:
        raise NotImplementedError
    def __rdivmod__(self, x: float) -> Tuple[float, float]:
        raise NotImplementedError
    def __pow__(self, x: float, mod: None = ...) -> float:
        raise NotImplementedError
    def __rpow__(self, x: float, mod: None = ...) -> float:
        raise NotImplementedError
    def __neg__(self) -> float:
        raise NotImplementedError
    def __pos__(self) -> float:
        raise NotImplementedError
    @overload
    def __round__(self) -> int:
        raise NotImplementedError
    @overload
    def __round__(self, ndigits: int) -> float:
        raise NotImplementedError
    def __abs__(self) -> float:
        raise NotImplementedError

class TAG_Float(BaseFloatTag): ...
class TAG_Double(BaseFloatTag): ...
