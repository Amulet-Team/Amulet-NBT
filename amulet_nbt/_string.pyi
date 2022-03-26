from typing import Union, Iterator
from ._value import BaseImmutableTag

class StringTag(BaseImmutableTag):
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
