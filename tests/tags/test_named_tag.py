import unittest
import itertools
import copy
import pickle

from amulet_nbt import (
    __major__,
    AbstractBaseNumericTag,
    AbstractBaseArrayTag,
    NamedTag,
    CompoundTag,
    ByteTag,
)

from tests.tags.abstract_base_tag import TestWrapper, TagNameMap


class NBTTests(TestWrapper.AbstractBaseTest):
    def test_constructor(self):
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = cls()

                named_tag = NamedTag(tag)
                self.assertIs(tag, named_tag.tag)
                self.assertEqual("", named_tag.name)

                name = "name"
                named_tag = NamedTag(tag, name)
                self.assertIs(tag, named_tag.tag)
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

    def test_equal(self):
        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
                    self.assertEqual(NamedTag(cls1()), NamedTag(cls2()))
                    self.assertEqual(NamedTag(cls1(), "name"), NamedTag(cls2(), "name"))
                elif __major__ <= 2 and (
                    (
                        issubclass(cls1, AbstractBaseNumericTag)
                        and issubclass(cls2, AbstractBaseNumericTag)
                    )
                    or (
                        issubclass(cls1, AbstractBaseArrayTag)
                        and issubclass(cls2, AbstractBaseArrayTag)
                    )
                ):
                    self.assertEqual(NamedTag(cls1()), NamedTag(cls2()))
                    self.assertEqual(NamedTag(cls1(), "name"), NamedTag(cls2(), "name"))
                else:
                    self.assertNotEqual(NamedTag(cls1()), NamedTag(cls2()))
                    self.assertNotEqual(
                        NamedTag(cls1(), "name"), NamedTag(cls2(), "name")
                    )
        for cls1 in self.nbt_types:
            self.assertNotEqual(NamedTag(cls1(), "name"), NamedTag(cls1(), "name2"))

    def test_copy(self):
        for cls in self.nbt_types:
            with self.subTest("Shallow Copy", cls=cls):
                named_tag = NamedTag(cls())
                named_tag2 = copy.copy(named_tag)

                self.assertIsNot(named_tag, named_tag2)
                self.assertEqual(named_tag, named_tag2)
                self.assertIs(named_tag.tag, named_tag2.tag)
                self.assertIs(named_tag.name, named_tag2.name)

            with self.subTest("Deep Copy", cls=cls):
                named_tag = NamedTag(cls())
                named_tag2 = copy.deepcopy(named_tag)

                self.assertIsNot(named_tag, named_tag2)
                self.assertEqual(named_tag, named_tag2)
                self.assertIsNot(named_tag.tag, named_tag2.tag)
                self.assertEqual(named_tag.tag, named_tag2.tag)
                self.assertEqual(named_tag.name, named_tag2.name)

    def test_pickle(self):
        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                tag = NamedTag(cls())
                dump = pickle.dumps(tag)
                tag2 = pickle.loads(dump)
                self.assertEqual(tag, tag2)

    def test_instance(self):
        self.assertIsInstance(NamedTag(), NamedTag)
        self.assertIsInstance(NamedTag().tag, CompoundTag)

        for cls in self.nbt_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(NamedTag(cls()), NamedTag)
                self.assertIsInstance(NamedTag(cls()).tag, cls)

                self.assertIsInstance(NamedTag(cls(), ""), NamedTag)
                self.assertIsInstance(NamedTag(cls(), "").tag, cls)

    def test_hash(self):
        with self.assertRaises(TypeError):
            hash(NamedTag())

    def test_repr(self):
        self.assertEqual('NamedTag(CompoundTag({}), "")', repr(NamedTag()))
        self.assertEqual(
            'NamedTag(CompoundTag({}), "name")', repr(NamedTag(name="name"))
        )
        self.assertEqual('NamedTag(ByteTag(0), "")', repr(NamedTag(ByteTag())))

    def test_attr(self):
        for cls1, cls2 in itertools.product(self.nbt_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                tag1 = cls1()
                tag2 = cls2()

                named_tag = NamedTag(tag1, "name")

                self.assertEqual("name", named_tag.name)
                named_tag.name = "name2"
                self.assertEqual("name2", named_tag.name)

                self.assertIs(tag1, named_tag.tag)
                named_tag.tag = tag2
                self.assertIs(tag2, named_tag.tag)

    def test_property(self):
        for cls in self.nbt_types:
            named_tag = NamedTag(cls())
            for cls2 in self.nbt_types:
                with self.subTest(cls=cls, cls2=cls2):
                    if cls is cls2:
                        getattr(named_tag, TagNameMap[cls2])
                    else:
                        with self.assertRaises(TypeError):
                            getattr(named_tag, TagNameMap[cls2])

    def test_iter(self):
        if __major__ <= 2:
            named_tag = NamedTag(
                CompoundTag(key1=ByteTag(), key2=ByteTag(), key3=ByteTag())
            )
            it = iter(named_tag)
            self.assertEqual("key1", next(it))
            self.assertEqual("key2", next(it))
            self.assertEqual("key3", next(it))
            with self.assertRaises(StopIteration):
                next(it)
        else:
            tag = CompoundTag()
            name = "name"
            named_tag = NamedTag(tag, name)
            it = iter(named_tag)
            self.assertIs(tag, next(it))
            self.assertIs(name, next(it))

    def test_getitem(self):
        a, b, c = ByteTag(), ByteTag(), ByteTag()
        tag = CompoundTag(a=a, b=b, c=c)
        name = "name"
        named_tag = NamedTag(tag, name)

        if __major__ <= 2:
            self.assertEqual(a, named_tag["a"])
            self.assertEqual(b, named_tag["b"])
            self.assertEqual(c, named_tag["c"])

        self.assertIs(name, named_tag[0])
        self.assertIs(tag, named_tag[1])
        with self.assertRaises(IndexError):
            named_tag[2]


if __name__ == "__main__":
    unittest.main()
