from typing import Union, Iterator, Any
from .value import BaseImmutableTag

class TAG_String(BaseImmutableTag, str):
    def __add__(self, s: str) -> str:
        raise NotImplementedError
    def __contains__(self, o: str) -> bool:
        raise NotImplementedError
    def __eq__(self, x: object) -> bool:
        raise NotImplementedError
    def __ge__(self, x: str) -> bool:
        raise NotImplementedError
    def __getitem__(self, i: Union[int, slice]) -> str:
        raise NotImplementedError
    def __gt__(self, x: str) -> bool:
        raise NotImplementedError
    def __iter__(self) -> Iterator[str]:
        raise NotImplementedError
    def __le__(self, x: str) -> bool:
        raise NotImplementedError
    def __len__(self) -> int:
        raise NotImplementedError
    def __lt__(self, x: str) -> bool:
        raise NotImplementedError
    def __mod__(self, x: Any) -> str:
        raise NotImplementedError
    def __mul__(self, n: int) -> str:
        raise NotImplementedError
    def __ne__(self, x: object) -> bool:
        raise NotImplementedError
    def __repr__(self) -> str:
        raise NotImplementedError
    def __rmul__(self, n: int) -> str:
        raise NotImplementedError

class Named_TAG_String(TAG_String):
    name: str
