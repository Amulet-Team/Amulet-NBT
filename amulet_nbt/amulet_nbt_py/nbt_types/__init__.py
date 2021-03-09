from typing import Union
from .int import TAG_Byte, TAG_Short, TAG_Int, TAG_Long
from .float import TAG_Float, TAG_Double
from .array import TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array
from .string import TAG_String
from .list import TAG_List
from .compound import TAG_Compound
from .nbtfile import NBTFile

AnyNBT = Union[
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
]
del Union
