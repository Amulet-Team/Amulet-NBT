from typing import Union, Iterator, overload, Any
from ._value import AbstractBaseImmutableTag

class StringTag(AbstractBaseImmutableTag):
    @overload
    def __init__(self, value: Any = ""): ...
    def __contains__(self, o: str) -> bool:
        raise NotImplementedError

    def __eq__(self, x: object) -> bool:
        raise NotImplementedError

    def __getitem__(self, i: Union[int, slice]) -> str:
        raise NotImplementedError

    def __iter__(self) -> Iterator[str]:
        raise NotImplementedError

    def __len__(self) -> int:
        raise NotImplementedError

    @property
    def py_str(self) -> str: ...
