import unittest
import itertools
import copy
import pickle

from amulet_nbt import (
    __major__,
    AbstractBaseTag,
    AbstractBaseImmutableTag,
    AbstractBaseNumericTag,
    AbstractBaseFloatTag,
    FloatTag,
    DoubleTag,
    from_snbt,
)

from tests.tags.abstract_base_tag import TestWrapper


class TestFloat(TestWrapper.AbstractBaseTagTest):
    def test_constructor(self):
        for float_cls in self.float_types:
            with self.subTest(float_cls=float_cls):
                float_cls()
                float_cls(5)
                float_cls(-5)
                float_cls(5.0)
                float_cls(-5.0)
                with self.assertRaises(TypeError):
                    float_cls(None)

        for cls in self.nbt_types:
            tag = cls()
            try:
                float(tag)
            except:
                pass
            else:
                for float_cls in self.float_types:
                    with self.subTest(cls=cls, float_cls=float_cls):
                        float_cls(tag)

        for obj in self.not_nbt:
            try:
                float(obj)
            except:
                pass
            else:
                for float_cls in self.float_types:
                    with self.subTest(obj=obj, float_cls=float_cls):
                        float_cls(obj)

    def test_equal(self):
        for cls1 in self.float_types:
            for cls2 in self.float_types:
                with self.subTest(cls1=cls1, cls2=cls2):
                    if cls1 is cls2 or __major__ <= 2:
                        self.assertEqual(cls1(), cls2())
                        self.assertEqual(cls1(), cls2(0))
                        self.assertNotEqual(cls1(5), cls2(10))
                    else:
                        self.assertNotEqual(cls1(), cls2())
                        self.assertNotEqual(cls1(), cls2(0))

            if __major__ <= 2:
                self.assertEqual(cls1(), 0)
                self.assertEqual(0, cls1())
            else:
                self.assertNotEqual(cls1(), 0)
                self.assertNotEqual(0, cls1())

    def test_py_data(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(cls().py_float, float)
                self.assertEqual(cls().py_float, 0.0)
                self.assertEqual(cls(5).py_float, 5.0)
                self.assertEqual(cls(5.5).py_float, 5.5)

    def test_copy(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_copy = copy.copy(tag)
                self.assertIsNot(tag, tag_copy)
                self.assertEqual(tag, tag_copy)
                self.assertEqual(tag.py_float, tag_copy.py_float)

                tag_deepcopy = copy.deepcopy(tag)
                self.assertIsNot(tag_deepcopy, tag_copy)
                self.assertEqual(tag_deepcopy, tag_copy)
                self.assertEqual(tag_deepcopy.py_float, tag_copy.py_float)

    def test_pickle(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()

                tag_pickled = pickle.dumps(tag)
                tag_2 = pickle.loads(tag_pickled)
                self.assertIsNot(tag, tag_2)
                self.assertEqual(tag, tag_2)
                self.assertEqual(tag.py_float, tag_2.py_float)

    def test_instance(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                tag = cls()
                self.assertIsInstance(tag, AbstractBaseTag)
                self.assertIsInstance(tag, AbstractBaseImmutableTag)
                self.assertIsInstance(tag, AbstractBaseNumericTag)
                self.assertIsInstance(tag, AbstractBaseFloatTag)
                self.assertIsInstance(tag, cls)

    def test_hash(self):
        for cls1, cls2 in itertools.product(self.float_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2:
                    self.assertEqual(hash(cls1()), hash(cls2()))
                else:
                    self.assertNotEqual(hash(cls1()), hash(cls2()))

    def test_repr(self):
        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertEqual(f"{cls.__name__}(0.0)", repr(cls()))
                self.assertEqual(f"{cls.__name__}(5.5)", repr(cls(5.5)))
                self.assertEqual(f"{cls.__name__}(-5.5)", repr(cls(-5.5)))

    def test_to_snbt(self):
        with self.subTest():
            self.assertEqual("-5.0f", FloatTag(-5).to_snbt())
            self.assertEqual("0.0f", FloatTag(0).to_snbt())
            self.assertEqual("5.0f", FloatTag(5).to_snbt())

        with self.subTest():
            self.assertEqual("-5.0d", DoubleTag(-5).to_snbt())
            self.assertEqual("0.0d", DoubleTag(0).to_snbt())
            self.assertEqual("5.0d", DoubleTag(5).to_snbt())

    def test_from_snbt(self):
        with self.subTest():
            self.assertStrictEqual(FloatTag(-5), from_snbt("-5.0f"))
            self.assertStrictEqual(FloatTag(-5), from_snbt("-5.0F"))
            self.assertStrictEqual(FloatTag(-5), from_snbt("-5f"))
            self.assertStrictEqual(FloatTag(-5), from_snbt("-5F"))
            self.assertStrictEqual(FloatTag(-5), from_snbt("-5.f"))
            self.assertStrictEqual(FloatTag(-5), from_snbt("-5.F"))
            self.assertStrictEqual(FloatTag(5), from_snbt("5.0f"))
            self.assertStrictEqual(FloatTag(5), from_snbt("5.0F"))
            self.assertStrictEqual(FloatTag(5), from_snbt("5f"))
            self.assertStrictEqual(FloatTag(5), from_snbt("5F"))
            self.assertStrictEqual(FloatTag(5), from_snbt("5.f"))
            self.assertStrictEqual(FloatTag(5), from_snbt("5.F"))

        with self.subTest():
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5.0d"))
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5.0D"))
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5.0"))
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5d"))
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5D"))
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5.d"))
            self.assertStrictEqual(DoubleTag(-5), from_snbt("-5.D"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5.0d"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5.0D"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5.0"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5d"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5D"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5.d"))
            self.assertStrictEqual(DoubleTag(5), from_snbt("5.D"))

    def test_numerical_operators(self):
        for cls1, cls2 in itertools.product(self.float_types, repeat=2):
            with self.subTest(cls1=cls1, cls2=cls2):
                if cls1 is cls2 or __major__ <= 2:
                    self.assertTrue(cls1(5) < cls2(10))
                    self.assertFalse(cls1(5) < cls2(5))
                    self.assertFalse(cls1(5) < cls2(0))

                    self.assertTrue(cls1(5) <= cls2(10))
                    self.assertTrue(cls1(5) <= cls2(5))
                    self.assertFalse(cls1(5) <= cls2(0))

                    self.assertFalse(cls1(5) > cls2(10))
                    self.assertFalse(cls1(5) > cls2(5))
                    self.assertTrue(cls1(5) > cls2(0))

                    self.assertFalse(cls1(5) >= cls2(10))
                    self.assertTrue(cls1(5) >= cls2(5))
                    self.assertTrue(cls1(5) >= cls2(0))
                else:
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) < cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) < cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) < cls2(0))

                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) <= cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) <= cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) <= cls2(0))

                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) > cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) > cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) > cls2(0))

                    with self.assertRaises(TypeError):
                        self.assertFalse(cls1(5) >= cls2(10))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) >= cls2(5))
                    with self.assertRaises(TypeError):
                        self.assertTrue(cls1(5) >= cls2(0))

        for cls in self.float_types:
            with self.subTest(cls=cls):
                self.assertIsInstance(int(cls(5.5)), int)
                self.assertEqual(5, int(cls(5.5)))

                self.assertIsInstance(float(cls(5.5)), float)
                self.assertEqual(5.5, float(cls(5.5)))

                self.assertIsInstance(bool(cls(5.5)), bool)
                self.assertEqual(False, bool(cls(0)))
                self.assertEqual(True, bool(cls(5.5)))


if __name__ == "__main__":
    unittest.main()
