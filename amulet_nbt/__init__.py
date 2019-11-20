try:
    from .amulet_cy_nbt import TAG_Byte, TAG_Short, TAG_Int, TAG_Long, TAG_Float, TAG_Double, \
        TAG_Byte_Array, TAG_String, TAG_List, TAG_Compound, TAG_Int_Array, TAG_Long_Array, \
        NBTFile, load, from_snbt, _TAG_Value, _TAG_Array
except (ImportError, ModuleNotFoundError) as e:
    from .amulet_py_nbt import TAG_Byte, TAG_Short, TAG_Int, TAG_Long, TAG_Float, TAG_Double, \
        TAG_Byte_Array, TAG_String, TAG_List, TAG_Compound, TAG_Int_Array, TAG_Long_Array, \
        NBTFile, load, from_snbt, _TAG_Value, _TAG_Array