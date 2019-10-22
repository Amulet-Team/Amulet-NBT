try:
    from .amulet_cy_nbt import TAG_Byte, TAG_Short, TAG_Int, TAG_Long, TAG_Float, TAG_Double, \
        TAG_Byte_Array, TAG_String, TAG_List, TAG_Compound, TAG_Int_Array, TAG_Long_Array, \
        NBTFile, load#, from_snbt

    if __debug__:
        print("Using Amulet NBT library")
except (ImportError, ModuleNotFoundError) as e:
    from .amulet_py_nbt import TAG_Byte, TAG_Short, TAG_Int, TAG_Long, TAG_Float, TAG_Double, \
        TAG_Byte_Array, TAG_String, TAG_List, TAG_Compound, TAG_Int_Array, TAG_Long_Array, \
        NBTFile, load, from_snbt

    if __debug__:
        traceback.print_exc()
        print("Using pure python NBT library")
