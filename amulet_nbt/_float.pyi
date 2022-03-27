from typing import SupportsFloat
from ._numeric import BaseNumericTag

class BaseFloatTag(BaseNumericTag):
    def __init__(self, value: SupportsFloat): ...

class FloatTag(BaseFloatTag): ...
class DoubleTag(BaseFloatTag): ...
