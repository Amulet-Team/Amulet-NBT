import unittest
import itertools
import copy
import pickle

import numpy
import numpy.testing

from amulet_nbt import (
    __major__,
    AbstractBaseTag,
    AbstractBaseMutableTag,
    AbstractBaseArrayTag,
    ByteArrayTag,
    IntArrayTag,
    LongArrayTag,
    from_snbt,
    SNBTParseError,
)

from tests.tags.abstract_base_tag import TestWrapper


class TestArray(TestWrapper.AbstractBaseTagTest):
    def test_constructor(self):
        for cls in self.array_types:
            with self.subTest(cls=cls):
                cls()
                cls([1, 2, 3])
                cls(numpy.array([1, 2, 3]))
                with self.assertRaises(TypeError):
                    cls(None)
                with self.assertRaises(ValueError):
                    cls("test")

            for cls2 in self.array_types:
                with self.subTest(cls=cls, cls2=cls2):
                    cls(cls2([1, 2, 3]))

    def test_equal(self):
        for cls1, cls2 in itertools.product(self.array_types, repeat=2):
            for arg1, arg2 in itertools.product(([], [1, 2, 3], [4, 5, 6]), repeat=2):
                with self.subTest(cls1=cls1, cls2=cls2, arg1=arg1, arg2=arg2):
                    a = cls1(arg1)
                    b = cls2(arg2)
                    if arg1 == arg2 and (cls1 is cls2 or __major__ <= 2):
                        self.assertEqual(a, b)
                    else:
                        self.assertNotEqual(a, b)

    def test_py_data(self):
        for cls in self.array_types:
            with self.subTest(cls=cls):
                inst = cls([1, 2, 3])
                arr = inst.np_array
                self.assertIsInstance(arr, numpy.ndarray)

                # should keep the same buffer
                arr[1] = 10
                self.assertEqual(10, inst[1])

    def test_set_get_item(self):
        for cls in self.array_types:
            with self.subTest("Get and set index", cls=cls):
                inst = cls([1, 2, 3])
                self.assertIsInstance(inst[0], numpy.signedinteger)
                self.assertEqual(1, inst[0])
                self.assertEqual(2, inst[1])
                self.assertEqual(3, inst[2])
                inst[1] = 10
                self.assertEqual(1, inst[0])
                self.assertEqual(10, inst[1])
                self.assertEqual(3, inst[2])

            with self.subTest("Get and set slice", cls=cls):
                inst = cls([1, 2, 3])
                self.assertIsInstance(inst[:], numpy.ndarray)
                numpy.testing.assert_array_equal([1, 2, 3], inst[:])
                numpy.testing.assert_array_equal([1, 3], inst[::2])
                inst[::2] = [4, 5]
                self.assertIsInstance(inst[:], numpy.ndarray)
                numpy.testing.assert_array_equal([4, 2, 5], inst[:])
                numpy.testing.assert_array_equal([4, 5], inst[::2])

    def test_copy(self):
        for cls in self.array_types:
            with self.subTest("Shallow Copy", cls=cls):
                # shallow copy should keep the same buffer
                inst = cls([1, 2, 3])
                inst2 = copy.copy(inst)
                self.assertEqual(inst, inst2)
                inst[1] = 10
                self.assertEqual(10, inst2[1])

            with self.subTest("Deep Copy", cls=cls):
                # deepcopy should create a new buffer
                inst = cls([1, 2, 3])
                inst2 = copy.deepcopy(inst)
                self.assertEqual(inst, inst2)
                inst[1] = 10
                self.assertNotEqual(10, inst2[1])

    def test_pickle(self):
        for cls1, cls2 in itertools.product(self.array_types, repeat=2):
            for arg1, arg2 in itertools.product(([], [1, 2, 3], [4, 5, 6]), repeat=2):
                with self.subTest(cls1=cls1, cls2=cls2, arg1=arg1, arg2=arg2):
                    a = cls1(arg1)
                    dump = pickle.dumps(cls2(arg2))
                    b = pickle.loads(dump)
                    if arg1 == arg2 and (cls1 is cls2 or __major__ <= 2):
                        self.assertEqual(a, b)
                    else:
                        self.assertNotEqual(a, b)

    def test_instance(self):
        for cls in self.array_types:
            for parent in (
                AbstractBaseTag,
                AbstractBaseMutableTag,
                AbstractBaseArrayTag,
                cls,
            ):
                with self.subTest(cls=cls, parent=parent):
                    self.assertIsInstance(cls(), parent)

    def test_hash(self):
        for cls in self.array_types:
            with self.subTest(cls=cls):
                with self.assertRaises(TypeError):
                    hash(cls())
                with self.assertRaises(TypeError):
                    hash(cls([1, 2, 3]))

    def test_repr(self):
        for cls in self.array_types:
            with self.subTest(cls=cls):
                self.assertEqual(f"{cls.__name__}([])", repr(cls()))
                self.assertEqual(
                    f"{cls.__name__}([-3, -2, -1, 0, 1, 2, 3])",
                    repr(cls([-3, -2, -1, 0, 1, 2, 3])),
                )

    def test_len(self):
        for cls in self.array_types:
            with self.subTest(cls=cls):
                self.assertEqual(0, len(cls()))
                self.assertEqual(3, len(cls([1, 2, 3])))

    def test_to_snbt(self):
        with self.subTest():
            self.assertEqual("[B;]", ByteArrayTag().to_snbt())
            self.assertEqual(
                "[B;-3B, -2B, -1B, 0B, 1B, 2B, 3B]",
                ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_snbt(),
            )
        with self.subTest():
            self.assertEqual("[I;]", IntArrayTag().to_snbt())
            self.assertEqual(
                "[I;-3, -2, -1, 0, 1, 2, 3]",
                IntArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_snbt(),
            )
        with self.subTest():
            self.assertEqual("[L;]", LongArrayTag().to_snbt())
            self.assertEqual(
                "[L;-3L, -2L, -1L, 0L, 1L, 2L, 3L]",
                LongArrayTag([-3, -2, -1, 0, 1, 2, 3]).to_snbt(),
            )

    def test_from_snbt(self):
        with self.subTest("ByteArrayTag"):
            self.assertStrictEqual(ByteArrayTag(), from_snbt("[B;]"))
            self.assertStrictEqual(
                ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                from_snbt("[B;-3b, -2b, -1b, 0b, 1b, 2b, 3b]"),
            )
            self.assertStrictEqual(
                ByteArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                from_snbt("[B;-3B, -2B, -1B, 0B, 1B, 2B, 3B]"),
            )
            with self.assertRaises(SNBTParseError):
                from_snbt(
                    "[B;-5, 5]",
                )
            with self.assertRaises(SNBTParseError):
                from_snbt(
                    "[B;-5.0B, 5.0B]",
                )

        with self.subTest("IntArrayTag"):
            self.assertStrictEqual(IntArrayTag(), from_snbt("[I;]"))
            self.assertStrictEqual(
                IntArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                from_snbt("[I;-3, -2, -1, 0, 1, 2, 3]"),
            )
            with self.assertRaises(SNBTParseError):
                from_snbt(
                    "[I;-5.0, 5.0]",
                )

        with self.subTest("LongArrayTag"):
            self.assertStrictEqual(LongArrayTag(), from_snbt("[L;]"))
            self.assertStrictEqual(
                LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                from_snbt("[L;-3l, -2l, -1l, 0l, 1l, 2l, 3l]"),
            )
            self.assertStrictEqual(
                LongArrayTag([-3, -2, -1, 0, 1, 2, 3]),
                from_snbt("[L;-3L, -2L, -1L, 0L, 1L, 2L, 3L]"),
            )
            with self.assertRaises(SNBTParseError):
                from_snbt(
                    "[L;-5, 5]",
                )
            with self.assertRaises(SNBTParseError):
                from_snbt(
                    "[L;-5.0L, 5.0L]",
                )


if __name__ == "__main__":
    unittest.main()
