from ._value import AbstractBaseImmutableTag

class AbstractBaseNumericTag(AbstractBaseImmutableTag):
    def __int__(self) -> int:
        raise NotImplementedError

    def __float__(self) -> float:
        raise NotImplementedError

    def __bool__(self) -> bool:
        raise NotImplementedError
