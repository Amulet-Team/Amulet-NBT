from .value import BaseTag, BaseValueType
from .int import TAG_Byte, TAG_Short, TAG_Int, TAG_Long
from .float import TAG_Float, TAG_Double
from .array import BaseArrayTag, BaseArrayType, TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array
from .string import TAG_String
from .list import TAG_List
from .compound import TAG_Compound
from .nbtfile import NBTFile
from .load_nbt import load
from .load_snbt import from_snbt

from .dtype import SNBTType, Int, Float, Number, Array, AnyNBT

from ._version import get_versions

__version__ = get_versions()["version"]
del get_versions
