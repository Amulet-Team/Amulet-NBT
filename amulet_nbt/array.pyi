import numpy
from .value import BaseMutableTag

class BaseArrayTag(BaseMutableTag, numpy.ndarray):
    def __init__(self, value=()): ...

class ByteArrayTag(BaseArrayTag): ...
class IntArrayTag(BaseArrayTag): ...
class LongArrayTag(BaseArrayTag): ...

class NamedByteArrayTag(ByteArrayTag):
    name: str

class NamedIntArrayTag(IntArrayTag):
    name: str

class NamedLongArrayTag(LongArrayTag):
    name: str
