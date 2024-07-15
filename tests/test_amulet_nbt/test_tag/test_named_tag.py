import unittest
import itertools
import copy
import pickle
import faulthandler

faulthandler.enable()

from amulet_nbt import (
    NamedTag,
    ByteTag,
    ShortTag,
    IntTag,
    LongTag,
    FloatTag,
    DoubleTag,
    StringTag,
    ListTag,
    CompoundTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    mutf8_encoding,
    utf8_encoding,
    utf8_escape_encoding,
    read_nbt,
)

from .test_abc import AbstractBaseTestCase, TagNameMap


class NamedTagTestCase(AbstractBaseTestCase, unittest.TestCase):
    def test_constructor(self) -> None:
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = cls()

                named_tag = NamedTag(tag)
                self.assertEqual(tag, named_tag.tag)
                self.assertEqual("", named_tag.name)

                name = "name"
                named_tag = NamedTag(tag, name)
                self.assertEqual(tag, named_tag.tag)
                self.assertEqual(name, named_tag.name)

        for obj in self.not_nbt:
            with self.subTest(obj=obj):
                if obj is None:
                    self.assertEqual(NamedTag(), NamedTag(None))
                else:
                    with self.assertRaises(TypeError):
                        NamedTag(obj)
                if not isinstance(obj, str):
                    with self.assertRaises(TypeError):
                        NamedTag(name=obj)

    def test_equal(self) -> None:
        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
                    self.assertEqual(NamedTag(cls1()), NamedTag(cls2()))
                    self.assertEqual(NamedTag(cls1(), "name"), NamedTag(cls2(), "name"))
                else:
                    self.assertNotEqual(NamedTag(cls1()), NamedTag(cls2()))
                    self.assertNotEqual(
                        NamedTag(cls1(), "name"), NamedTag(cls2(), "name")
                    )
        for cls1 in self.nbt_types:
            self.assertNotEqual(NamedTag(cls1(), "name"), NamedTag(cls1(), "name2"))

    def test_repr(self) -> None:
        self.assertEqual("NamedTag(CompoundTag({}), '')", repr(NamedTag()))
        self.assertEqual(
            "NamedTag(CompoundTag({}), 'name')", repr(NamedTag(name="name"))
        )
        self.assertEqual("NamedTag(ByteTag(0), '')", repr(NamedTag(ByteTag())))

    def test_str(self) -> None:
        # undefined
        pass

    def test_pickle(self) -> None:
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = NamedTag(cls())
                dump = pickle.dumps(tag)
                tag2 = pickle.loads(dump)
                self.assertEqual(tag, tag2)

    def test_copy(self) -> None:
        for cls in self.nbt_types:
            named_tag = NamedTag(cls())
            named_tag2 = copy.copy(named_tag)

            self.assertIsNot(named_tag, named_tag2)
            self.assertEqual(named_tag, named_tag2)
            self.assertEqual(named_tag.tag, named_tag2.tag)
            named_tag.tag = ByteTag(-1)
            self.assertNotEqual(named_tag.tag, named_tag2.tag)
            self.assertEqual(named_tag.name, named_tag2.name)
            named_tag.name = "hello world"
            self.assertNotEqual(named_tag.name, named_tag2.name)

        named_tag = NamedTag(CompoundTag())
        named_tag2 = copy.copy(named_tag)
        named_tag.compound["key"] = ByteTag()
        self.assertEqual(named_tag, named_tag2)

        named_tag = NamedTag(ListTag())
        named_tag2 = copy.copy(named_tag)
        named_tag.list.append(ByteTag())
        self.assertEqual(named_tag, named_tag2)

    def test_deepcopy(self) -> None:
        for cls in self.nbt_types:
            named_tag = NamedTag(cls())
            named_tag2 = copy.deepcopy(named_tag)

            self.assertIsNot(named_tag, named_tag2)
            self.assertEqual(named_tag, named_tag2)
            self.assertIsNot(named_tag.tag, named_tag2.tag)
            self.assertEqual(named_tag.tag, named_tag2.tag)
            self.assertEqual(named_tag.name, named_tag2.name)

        named_tag = NamedTag(CompoundTag())
        named_tag2 = copy.deepcopy(named_tag)
        named_tag.compound["key"] = ByteTag()
        self.assertNotEqual(named_tag, named_tag2)

        named_tag = NamedTag(ListTag())
        named_tag2 = copy.deepcopy(named_tag)
        named_tag.list.append(ByteTag())
        self.assertNotEqual(named_tag, named_tag2)

    def test_hash(self) -> None:
        with self.assertRaises(TypeError):
            hash(NamedTag())

    def test_instance(self) -> None:
        self.assertIsInstance(NamedTag(), NamedTag)
        self.assertIsInstance(NamedTag().tag, CompoundTag)

        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(NamedTag(cls()), NamedTag)
                self.assertIsInstance(NamedTag(cls()).tag, cls)

                self.assertIsInstance(NamedTag(cls(), ""), NamedTag)
                self.assertIsInstance(NamedTag(cls(), "").tag, cls)

    def test_attr(self) -> None:
        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                tag1 = cls1()
                tag2 = cls2()

                named_tag = NamedTag(tag1, "name")

                self.assertEqual("name", named_tag.name)
                named_tag.name = "name2"
                self.assertEqual("name2", named_tag.name)

                self.assertEqual(tag1, named_tag.tag)
                named_tag.tag = tag2
                self.assertEqual(tag2, named_tag.tag)

        self.assertEqual(b"\xFF", NamedTag(name=b"\xFF").name)

    def test_property(self) -> None:
        for cls in self.nbt_types:
            named_tag = NamedTag(cls())
            for cls2 in self.nbt_types:
                with self.subTest(cls=cls, cls2=cls2):
                    if cls is cls2:
                        getattr(named_tag, TagNameMap[cls2])
                    else:
                        with self.assertRaises(TypeError):
                            getattr(named_tag, TagNameMap[cls2])

    def test_iter(self) -> None:
        tag = CompoundTag()
        name = "name"
        named_tag = NamedTag(tag, name)
        it = iter(named_tag)
        self.assertEqual(name, next(it))
        self.assertEqual(tag, next(it))

    def test_getitem(self) -> None:
        a, b, c = ByteTag(), ByteTag(), ByteTag()
        tag = CompoundTag(a=a, b=b, c=c)
        name = "name"
        named_tag = NamedTag(tag, name)

        self.assertEqual(name, named_tag[0])
        self.assertEqual(tag, named_tag[1])
        with self.assertRaises(IndexError):
            named_tag[2]  # type: ignore

    def test_to_nbt(self) -> None:
        for cls in self.nbt_types:
            tag = cls()
            name = "hello world"
            named_tag = NamedTag(tag, name)
            for little_endian in (True, False):
                for compressed in (True, False):
                    for string_encoding in (
                        mutf8_encoding,
                        utf8_encoding,
                        utf8_escape_encoding,
                    ):
                        with self.subTest(
                            cls=cls,
                            little_endian=little_endian,
                            compressed=compressed,
                            string_encoding=string_encoding,
                        ):
                            self.assertEqual(
                                tag.to_nbt(
                                    compressed=compressed,
                                    little_endian=little_endian,
                                    string_encoding=string_encoding,
                                    name=name,
                                ),
                                named_tag.to_nbt(
                                    compressed=compressed,
                                    little_endian=little_endian,
                                    string_encoding=string_encoding,
                                ),
                            )

    def test_from_nbt(self) -> None:
        for bnbt, correct_named_tag in (
            (b"\x01\x00\x00\x01", NamedTag(ByteTag(1))),
            (b"\x02\x00\x00\x00\x01", NamedTag(ShortTag(1))),
            (b"\x03\x00\x00\x00\x00\x00\x01", NamedTag(IntTag(1))),
            (b"\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01", NamedTag(LongTag(1))),
            (b"\x05\x00\x00\x3F\x80\x00\x00", NamedTag(FloatTag(1))),
            (b"\x06\x00\x00\x3F\xf0\x00\x00\x00\x00\x00\x00", NamedTag(DoubleTag(1))),
            (b"\x07\x00\x00\x00\x00\x00\x00", NamedTag(ByteArrayTag())),
            (b"\x08\x00\x00\x00\x0Bhello world", NamedTag(StringTag("hello world"))),
            (b"\x09\x00\x00\x01\x00\x00\x00\x00", NamedTag(ListTag())),
            (b"\x0A\x00\x00\x00", NamedTag(CompoundTag())),
            (b"\x0B\x00\x00\x00\x00\x00\x00", NamedTag(IntArrayTag())),
            (b"\x0C\x00\x00\x00\x00\x00\x00", NamedTag(LongArrayTag())),
        ):
            with self.subTest(str(bnbt)):
                named_tag = read_nbt(bnbt, compressed=False)
                self.assertIsInstance(named_tag, NamedTag)
                self.assertEqual(correct_named_tag, named_tag)
                self.assertEqual(correct_named_tag.tag, named_tag.tag)

        self.assertEqual(
            "hello world",
            read_nbt(b"\x01\x00\x0Bhello world\x01", compressed=False).name,
        )

    def test_to_snbt(self) -> None:
        named_tag = NamedTag(CompoundTag())
        self.assertEqual("{}", named_tag.to_snbt())

    def test_from_snbt(self) -> None:
        pass


if __name__ == "__main__":
    unittest.main()
