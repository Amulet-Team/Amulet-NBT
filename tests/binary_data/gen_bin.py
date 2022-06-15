"""
Creates an example of the binary format for each nbt class.
The printed result is used in test_nbt_read_write.py
This is here in case that data needs to be recreated in the future.
"""
from typing import Tuple, Type, Any, Iterable
from amulet_nbt import (
    AbstractBaseTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    StringTag,
    ListTag,
    CompoundTag,
    NamedTag,
)

names = ("", "name")
tags: Tuple[Tuple[Tuple[Type[AbstractBaseTag], ...], Tuple[Any, ...]], ...] = (
    ((ByteTag, ShortTag, IntTag, LongTag, FloatTag, DoubleTag), (5, -5)),
    ((ByteArrayTag, IntArrayTag, LongArrayTag), ([], [5, 6, 7], [-5, -6, -7])),
    ((StringTag,), ("value",)),
    ((ListTag,), ([],)),
    ((CompoundTag,), ({},)),
)


def print_line(name: str, tag: AbstractBaseTag):
    named_tag = NamedTag(tag, name)
    print(
        f"("
        f"{repr(named_tag)}, "
        f"{repr(named_tag.to_nbt(compressed=False, little_endian=False))}, "
        f"{repr(named_tag.to_nbt(compressed=False, little_endian=True))}, "
        f"{repr(named_tag.to_nbt(compressed=True, little_endian=False))}, "
        f"{repr(named_tag.to_nbt(compressed=True, little_endian=True))}, "
        f"{repr(named_tag.tag.to_snbt())}"
        f"),"
    )


def gen_data() -> Iterable[AbstractBaseTag]:
    for dtypes, values in tags:
        for tag in dtypes:
            for value in values:
                yield tag(value)


def gen_data_all() -> Iterable[AbstractBaseTag]:
    yield from gen_data()
    for data in gen_data():
        yield ListTag([data])
    for data in gen_data():
        yield CompoundTag({"key": data})


def main():
    for name in names:
        for data in gen_data_all():
            print_line(name, data)
        print()


if __name__ == "__main__":
    main()
