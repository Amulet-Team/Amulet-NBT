import unittest

from amulet_nbt import (
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
)


class BaseTypeTest(unittest.TestCase):
    def setUp(self):
        self._int_types = (
            TAG_Byte,
            TAG_Short,
            TAG_Int,
            TAG_Long,
        )
        self._float_types = (
            TAG_Float,
            TAG_Double,
        )
        self._numerical_types = self._int_types + self._float_types
        self._str_types = (TAG_String,)
        self._array_types = (
            TAG_Byte_Array,
            TAG_Int_Array,
            TAG_Long_Array,
        )
        self._container_types = (
            TAG_List,
            TAG_Compound,
        )
        self._nbt_types = (
            self._numerical_types
            + self._str_types
            + self._array_types
            + self._container_types
        )

        self._not_nbt = (None, True, False, 0, 0.0, "str", [], {}, set())

    def _iter_instance(self):
        for cls in self._nbt_types:
            yield cls()

    def test_init_empty(self):
        raise NotImplementedError

    def test_init(self):
        raise NotImplementedError

    def test_errors(self):
        raise NotImplementedError
