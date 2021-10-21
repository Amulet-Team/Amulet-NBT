"""
Creates an example of the binary format for each nbt class.
The printed result is used in test_nbt_read_write.py
This is here in case that data needs to be recreated in the future.
"""
from typing import Tuple, Type, Any, Iterable
from amulet_nbt import (
    BaseTag,
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
    NBTFile,
)

names = ("", "name")
tags: Tuple[Tuple[Tuple[Type[BaseTag], ...], Tuple[Any, ...]], ...] = (
    ((TAG_Byte, TAG_Short, TAG_Int, TAG_Long, TAG_Float, TAG_Double), (5, -5)),
    ((TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array), ([], [5, 6, 7], [-5, -6, -7])),
    ((TAG_String,), ("value",)),
    ((TAG_List,), ([],)),
    ((TAG_Compound,), ({},)),
)


def print_line(name: str, value: BaseTag):
    nbt_file = NBTFile(value, name)
    be_bytes = nbt_file.to_nbt(compressed=False)
    le_bytes = nbt_file.to_nbt(compressed=False, little_endian=True)
    print(f"(" f"{repr(nbt_file)}, " f"{be_bytes}, " f"{le_bytes}" f"),")


def gen_data() -> Iterable[BaseTag]:
    for dtypes, values in tags:
        for tag in dtypes:
            for value in values:
                yield tag(value)


def gen_data_all() -> Iterable[BaseTag]:
    yield from gen_data()
    for data in gen_data():
        yield TAG_List([data])
    for data in gen_data():
        yield TAG_Compound({"key": data})


def main():
    for name in names:
        for data in gen_data_all():
            print_line(name, data)
        print()


if __name__ == "__main__":
    main()
