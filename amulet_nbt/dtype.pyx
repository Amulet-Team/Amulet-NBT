from typing import Union

from .int cimport TAG_Byte, TAG_Short, TAG_Int, TAG_Long
from .float cimport TAG_Float, TAG_Double
from .array cimport (
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array,
)
from .string cimport TAG_String
from .list cimport TAG_List
from .compound cimport TAG_Compound

SNBTType = str

IntType = Union[
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long
]

FloatType = Union[
    TAG_Float,
    TAG_Double
]

NumberType = Union[
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double
]

ArrayType = Union[
    TAG_Byte_Array,
    TAG_Int_Array,
    TAG_Long_Array
]

AnyNBT = Union[
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_Byte_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
    TAG_Int_Array,
    TAG_Long_Array
]
