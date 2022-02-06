import numpy
from .value import BaseMutableTag

class BaseArrayTag(BaseMutableTag, numpy.ndarray):
    def __init__(self, value=()): ...

class TAG_Byte_Array(BaseArrayTag): ...
class TAG_Int_Array(BaseArrayTag): ...
class TAG_Long_Array(BaseArrayTag): ...

class Named_TAG_Byte_Array(TAG_Byte_Array):
    name: str

class Named_TAG_Int_Array(TAG_Int_Array):
    name: str

class Named_TAG_Long_Array(TAG_Long_Array):
    name: str
