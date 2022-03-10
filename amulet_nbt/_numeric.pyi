from typing import Optional
from ._value import BaseImmutableTag

class BaseNumericTag(BaseImmutableTag):
    def __trunc__(self) -> int:
        raise NotImplementedError
    def __ceil__(self) -> int:
        raise NotImplementedError
    def __floor__(self) -> int:
        raise NotImplementedError
    def __float__(self) -> float:
        raise NotImplementedError
    def __int__(self) -> int:
        raise NotImplementedError
    def __bool__(self) -> bool:
        raise NotImplementedError
    def __abs__(self):
        raise NotImplementedError
    def __add__(self, x):
        raise NotImplementedError
    def __radd__(self, x):
        raise NotImplementedError
    def __iadd__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __sub__(self, x):
        raise NotImplementedError
    def __rsub__(self, x):
        raise NotImplementedError
    def __isub__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __mul__(self, x):
        raise NotImplementedError
    def __rmul__(self, x):
        raise NotImplementedError
    def __imul__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __floordiv__(self, x):
        raise NotImplementedError
    def __rfloordiv__(self, x):
        raise NotImplementedError
    def __ifloordiv__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __truediv__(self, x) -> float:
        raise NotImplementedError
    def __rtruediv__(self, x) -> float:
        raise NotImplementedError
    def __itruediv__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __mod__(self, x):
        raise NotImplementedError
    def __rmod__(self, x):
        raise NotImplementedError
    def __imod__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __divmod__(self, x):
        raise NotImplementedError
    def __rdivmod__(self, x):
        raise NotImplementedError
    def __pow__(self, x, mod=None):
        raise NotImplementedError
    def __rpow__(self, x, mod=None):
        raise NotImplementedError
    def __ipow__(self, other) -> BaseNumericTag:
        raise NotImplementedError
    def __neg__(self):
        raise NotImplementedError
    def __pos__(self):
        raise NotImplementedError
    def __round__(self, ndigits: Optional[int] = None):
        raise NotImplementedError
