import unittest
from copy import deepcopy

from amulet_nbt import (
    BaseTag,
    TAG_Byte,
    TAG_Short,
    TAG_Int,
    TAG_Long,
    TAG_Float,
    TAG_Double,
    TAG_Byte_Array,
    TAG_String,
    TAG_List,
    TAG_Compound,
    TAG_Int_Array,
    TAG_Long_Array,
)


class TestNumerical(unittest.TestCase):
    def test_strict_equals(self):
        tags = (
            5,
            5.0,
            "value",
            [0],
            {"key", 0},
            TAG_Byte(),
            TAG_Byte(5),
            TAG_Short(),
            TAG_Short(5),
            TAG_Int(),
            TAG_Int(5),
            TAG_Long(),
            TAG_Long(5),
            TAG_Float(),
            TAG_Float(5.0),
            TAG_Double(),
            TAG_Double(5.0),
            TAG_String(),
            TAG_String("value"),
            TAG_List(),
            TAG_List([TAG_Byte()]),
            TAG_List([TAG_Short()]),
            TAG_List([TAG_Int()]),
            TAG_List([TAG_Long()]),
            TAG_List([TAG_Float()]),
            TAG_List([TAG_Double()]),
            TAG_List([TAG_String()]),
            TAG_List([TAG_List()]),
            TAG_List([TAG_Compound()]),
            TAG_List([TAG_Byte_Array()]),
            TAG_List([TAG_Int_Array()]),
            TAG_List([TAG_Long_Array()]),
            TAG_Compound(),
            TAG_Compound({"key": TAG_Byte()}),
            TAG_Compound({"key": TAG_Short()}),
            TAG_Compound({"key": TAG_Int()}),
            TAG_Compound({"key": TAG_Long()}),
            TAG_Compound({"key": TAG_Float()}),
            TAG_Compound({"key": TAG_Double()}),
            TAG_Compound({"key": TAG_String()}),
            TAG_Compound({"key": TAG_List()}),
            TAG_Compound({"key": TAG_Compound()}),
            TAG_Compound({"key": TAG_Byte_Array()}),
            TAG_Compound({"key": TAG_Int_Array()}),
            TAG_Compound({"key": TAG_Long_Array()}),
            TAG_Byte_Array(),
            TAG_Byte_Array([1, 2, 3]),
            TAG_Int_Array(),
            TAG_Int_Array([1, 2, 3]),
            TAG_Long_Array(),
            TAG_Long_Array([1, 2, 3]),
        )
        for tag1 in tags:
            for tag2 in tags:
                if isinstance(tag1, BaseTag):
                    if tag1 is tag2:
                        self.assertTrue(
                            tag1.strict_equals(tag2), msg=f"{repr(tag1)} {repr(tag2)}"
                        )
                        self.assertTrue(
                            tag1.strict_equals(deepcopy(tag2)),
                            msg=f"{repr(tag1)} {repr(tag2)}",
                        )
                    else:
                        self.assertFalse(
                            tag1.strict_equals(tag2), msg=f"{repr(tag1)} {repr(tag2)}"
                        )


if __name__ == "__main__":
    unittest.main()
