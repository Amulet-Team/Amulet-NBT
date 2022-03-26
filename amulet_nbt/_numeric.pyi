from ._value import BaseImmutableTag

class BaseNumericTag(BaseImmutableTag):
    def __int__(self) -> int:
        raise NotImplementedError
    def __float__(self) -> float:
        raise NotImplementedError
    def __bool__(self) -> bool:
        raise NotImplementedError
