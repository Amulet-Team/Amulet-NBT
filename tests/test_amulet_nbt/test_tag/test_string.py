import copy
import pickle
import itertools
import unittest
import faulthandler

faulthandler.enable()

from .test_abc import AbstractBaseImmutableTagTestCase

from amulet_nbt import StringTag, AbstractBaseTag, AbstractBaseImmutableTag


class StringTagTestCase(AbstractBaseImmutableTagTestCase, unittest.TestCase):
    def test_constructor(self):
        StringTag("value")
        StringTag(StringTag("value"))

    def test_equal(self):
        self.assertEqual(StringTag("value"), StringTag("value"))
        self.assertNotEqual(StringTag("value"), StringTag("value2"))
        self.assertEqual(StringTag(StringTag("value")), StringTag("value"))
        self.assertEqual(StringTag("value"), StringTag(StringTag("value")))

    def test_py_data(self):
        self.assertIsNot(StringTag("value").py_str, str)
        self.assertEqual("value", StringTag("value").py_str)
        self.assertEqual("None", StringTag(None).py_str)

    def test_repr(self):
        self.assertEqual('StringTag("")', repr(StringTag()))
        self.assertEqual('StringTag("value")', repr(StringTag("value")))
        self.assertEqual('StringTag("quote\\"value")', repr(StringTag('quote"value')))
        self.assertEqual('StringTag("quote\'value")', repr(StringTag("quote'value")))

    def test_str(self) -> None:
        pass

    def test_pickle(self):
        pass
        # tag = StringTag("value")
        #
        # tag_pickled = pickle.dumps(tag)
        # tag_2 = pickle.loads(tag_pickled)
        # self.assertIsNot(tag, tag_2)
        # self.assertEqual(tag, tag_2)
        # self.assertEqual(tag.py_str, tag_2.py_str)

    def test_copy(self):
        pass
        # tag = StringTag("value")
        #
        # tag_copy = copy.copy(tag)
        # self.assertIsNot(tag, tag_copy)
        # self.assertEqual(tag, tag_copy)
        # self.assertEqual(tag.py_str, tag_copy.py_str)

    def test_deepcopy(self) -> None:
        pass
        # tag = StringTag("value")
        #
        # tag_deepcopy = copy.deepcopy(tag)
        # self.assertIsNot(tag, tag_deepcopy)
        # self.assertEqual(tag, tag_deepcopy)
        # self.assertEqual(tag.py_str, tag_deepcopy.py_str)

    def test_hash(self):
        self.assertEqual(hash(StringTag("value")), hash(StringTag("value")))
        self.assertNotEqual(hash(StringTag("value")), hash(StringTag("value2")))

    def test_instance(self):
        self.assertIsInstance(StringTag(), AbstractBaseTag)
        self.assertIsInstance(StringTag(), AbstractBaseImmutableTag)
        self.assertIsInstance(StringTag(), StringTag)

    def test_comp(self):
        self.assertFalse(StringTag("val1") < StringTag("val0"))
        self.assertFalse(StringTag("val1") < StringTag("val1"))
        self.assertTrue(StringTag("val1") < StringTag("val2"))

        self.assertFalse(StringTag("val1") <= StringTag("val0"))
        self.assertTrue(StringTag("val1") <= StringTag("val1"))
        self.assertTrue(StringTag("val1") <= StringTag("val2"))

        self.assertTrue(StringTag("val1") > StringTag("val0"))
        self.assertFalse(StringTag("val1") > StringTag("val1"))
        self.assertFalse(StringTag("val1") > StringTag("val2"))

        self.assertTrue(StringTag("val1") >= StringTag("val0"))
        self.assertTrue(StringTag("val1") >= StringTag("val1"))
        self.assertFalse(StringTag("val1") >= StringTag("val2"))


if __name__ == "__main__":
    unittest.main()
