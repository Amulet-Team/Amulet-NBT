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


class TestRepr(unittest.TestCase):
    def test_repr(self):
        self.assertEqual(repr(TAG_Byte(5)), "TAG_Byte(5)")
        self.assertEqual(repr(TAG_Byte(-5)), "TAG_Byte(-5)")
        self.assertEqual(repr(TAG_Short(5)), "TAG_Short(5)")
        self.assertEqual(repr(TAG_Short(-5)), "TAG_Short(-5)")
        self.assertEqual(repr(TAG_Int(5)), "TAG_Int(5)")
        self.assertEqual(repr(TAG_Int(-5)), "TAG_Int(-5)")
        self.assertEqual(repr(TAG_Long(5)), "TAG_Long(5)")
        self.assertEqual(repr(TAG_Long(-5)), "TAG_Long(-5)")
        self.assertEqual(repr(TAG_Float(5)), "TAG_Float(5.0)")
        self.assertEqual(repr(TAG_Float(-5)), "TAG_Float(-5.0)")
        self.assertEqual(repr(TAG_Double(5)), "TAG_Double(5.0)")
        self.assertEqual(repr(TAG_Double(-5)), "TAG_Double(-5.0)")
        self.assertEqual(repr(TAG_String("value")), 'TAG_String("value")')
        self.assertEqual(
            repr(TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])),
            "TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])",
        )
        self.assertEqual(
            repr(TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])),
            "TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])",
        )
        self.assertEqual(
            repr(TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])),
            "TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])",
        )
        self.assertEqual(repr(TAG_List()), "TAG_List([], 1)")

    def test_repr_list(self):
        self.assertEqual(repr(TAG_List([TAG_Byte(-5)])), "TAG_List([TAG_Byte(-5)], 1)")
        self.assertEqual(
            repr(TAG_List([TAG_Byte(-5), TAG_Byte(-5)])),
            "TAG_List([TAG_Byte(-5), TAG_Byte(-5)], 1)",
        )
        self.assertEqual(repr(TAG_List([TAG_Byte(5)])), "TAG_List([TAG_Byte(5)], 1)")
        self.assertEqual(
            repr(TAG_List([TAG_Byte(5), TAG_Byte(5)])),
            "TAG_List([TAG_Byte(5), TAG_Byte(5)], 1)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Short(-5)])), "TAG_List([TAG_Short(-5)], 2)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_Short(-5), TAG_Short(-5)])),
            "TAG_List([TAG_Short(-5), TAG_Short(-5)], 2)",
        )
        self.assertEqual(repr(TAG_List([TAG_Short(5)])), "TAG_List([TAG_Short(5)], 2)")
        self.assertEqual(
            repr(TAG_List([TAG_Short(5), TAG_Short(5)])),
            "TAG_List([TAG_Short(5), TAG_Short(5)], 2)",
        )
        self.assertEqual(repr(TAG_List([TAG_Int(-5)])), "TAG_List([TAG_Int(-5)], 3)")
        self.assertEqual(
            repr(TAG_List([TAG_Int(-5), TAG_Int(-5)])),
            "TAG_List([TAG_Int(-5), TAG_Int(-5)], 3)",
        )
        self.assertEqual(repr(TAG_List([TAG_Int(5)])), "TAG_List([TAG_Int(5)], 3)")
        self.assertEqual(
            repr(TAG_List([TAG_Int(5), TAG_Int(5)])),
            "TAG_List([TAG_Int(5), TAG_Int(5)], 3)",
        )
        self.assertEqual(repr(TAG_List([TAG_Long(-5)])), "TAG_List([TAG_Long(-5)], 4)")
        self.assertEqual(
            repr(TAG_List([TAG_Long(-5), TAG_Long(-5)])),
            "TAG_List([TAG_Long(-5), TAG_Long(-5)], 4)",
        )
        self.assertEqual(repr(TAG_List([TAG_Long(5)])), "TAG_List([TAG_Long(5)], 4)")
        self.assertEqual(
            repr(TAG_List([TAG_Long(5), TAG_Long(5)])),
            "TAG_List([TAG_Long(5), TAG_Long(5)], 4)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Float(-5)])), "TAG_List([TAG_Float(-5.0)], 5)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_Float(-5), TAG_Float(-5)])),
            "TAG_List([TAG_Float(-5.0), TAG_Float(-5.0)], 5)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Float(5)])), "TAG_List([TAG_Float(5.0)], 5)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_Float(5), TAG_Float(5)])),
            "TAG_List([TAG_Float(5.0), TAG_Float(5.0)], 5)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Double(-5)])), "TAG_List([TAG_Double(-5.0)], 6)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_Double(-5), TAG_Double(-5)])),
            "TAG_List([TAG_Double(-5.0), TAG_Double(-5.0)], 6)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Double(5)])), "TAG_List([TAG_Double(5.0)], 6)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_Double(5), TAG_Double(5)])),
            "TAG_List([TAG_Double(5.0), TAG_Double(5.0)], 6)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])])),
            "TAG_List([TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])], 7)",
        )
        self.assertEqual(
            repr(
                TAG_List(
                    [
                        TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3]),
                        TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
            "TAG_List([TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3]), TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])], 7)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_String("value")])), 'TAG_List([TAG_String("value")], 8)'
        )
        self.assertEqual(
            repr(TAG_List([TAG_String("value"), TAG_String("value")])),
            'TAG_List([TAG_String("value"), TAG_String("value")], 8)',
        )
        self.assertEqual(
            repr(TAG_List([TAG_List([])])), "TAG_List([TAG_List([], 1)], 9)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_List([]), TAG_List([])])),
            "TAG_List([TAG_List([], 1), TAG_List([], 1)], 9)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Compound({})])), "TAG_List([TAG_Compound({})], 10)"
        )
        self.assertEqual(
            repr(TAG_List([TAG_Compound({}), TAG_Compound({})])),
            "TAG_List([TAG_Compound({}), TAG_Compound({})], 10)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])])),
            "TAG_List([TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])], 11)",
        )
        self.assertEqual(
            repr(
                TAG_List(
                    [
                        TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3]),
                        TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
            "TAG_List([TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3]), TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])], 11)",
        )
        self.assertEqual(
            repr(TAG_List([TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])])),
            "TAG_List([TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])], 12)",
        )
        self.assertEqual(
            repr(
                TAG_List(
                    [
                        TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3]),
                        TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3]),
                    ]
                )
            ),
            "TAG_List([TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3]), TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])], 12)",
        )

    def test_repr_compound(self):
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Byte(-5)})),
            "TAG_Compound({'key': TAG_Byte(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Byte(-5), "a": TAG_Byte(-5)})),
            "TAG_Compound({'b': TAG_Byte(-5), 'a': TAG_Byte(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Byte(5)})),
            "TAG_Compound({'key': TAG_Byte(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Byte(5), "a": TAG_Byte(5)})),
            "TAG_Compound({'b': TAG_Byte(5), 'a': TAG_Byte(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Short(-5)})),
            "TAG_Compound({'key': TAG_Short(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Short(-5), "a": TAG_Short(-5)})),
            "TAG_Compound({'b': TAG_Short(-5), 'a': TAG_Short(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Short(5)})),
            "TAG_Compound({'key': TAG_Short(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Short(5), "a": TAG_Short(5)})),
            "TAG_Compound({'b': TAG_Short(5), 'a': TAG_Short(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Int(-5)})),
            "TAG_Compound({'key': TAG_Int(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Int(-5), "a": TAG_Int(-5)})),
            "TAG_Compound({'b': TAG_Int(-5), 'a': TAG_Int(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Int(5)})), "TAG_Compound({'key': TAG_Int(5)})"
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Int(5), "a": TAG_Int(5)})),
            "TAG_Compound({'b': TAG_Int(5), 'a': TAG_Int(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Long(-5)})),
            "TAG_Compound({'key': TAG_Long(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Long(-5), "a": TAG_Long(-5)})),
            "TAG_Compound({'b': TAG_Long(-5), 'a': TAG_Long(-5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Long(5)})),
            "TAG_Compound({'key': TAG_Long(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Long(5), "a": TAG_Long(5)})),
            "TAG_Compound({'b': TAG_Long(5), 'a': TAG_Long(5)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Float(-5)})),
            "TAG_Compound({'key': TAG_Float(-5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Float(-5), "a": TAG_Float(-5)})),
            "TAG_Compound({'b': TAG_Float(-5.0), 'a': TAG_Float(-5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Float(5)})),
            "TAG_Compound({'key': TAG_Float(5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Float(5), "a": TAG_Float(5)})),
            "TAG_Compound({'b': TAG_Float(5.0), 'a': TAG_Float(5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Double(-5)})),
            "TAG_Compound({'key': TAG_Double(-5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Double(-5), "a": TAG_Double(-5)})),
            "TAG_Compound({'b': TAG_Double(-5.0), 'a': TAG_Double(-5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Double(5)})),
            "TAG_Compound({'key': TAG_Double(5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Double(5), "a": TAG_Double(5)})),
            "TAG_Compound({'b': TAG_Double(5.0), 'a': TAG_Double(5.0)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])})),
            "TAG_Compound({'key': TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(
                TAG_Compound(
                    {
                        "b": TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3]),
                        "a": TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3]),
                    }
                )
            ),
            "TAG_Compound({'b': TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3]), 'a': TAG_Byte_Array([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_String("value")})),
            "TAG_Compound({'key': TAG_String(\"value\")})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_String("value"), "a": TAG_String("value")})),
            "TAG_Compound({'b': TAG_String(\"value\"), 'a': TAG_String(\"value\")})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_List([])})),
            "TAG_Compound({'key': TAG_List([], 1)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_List([]), "a": TAG_List([])})),
            "TAG_Compound({'b': TAG_List([], 1), 'a': TAG_List([], 1)})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Compound({})})),
            "TAG_Compound({'key': TAG_Compound({})})",
        )
        self.assertEqual(
            repr(TAG_Compound({"b": TAG_Compound({}), "a": TAG_Compound({})})),
            "TAG_Compound({'b': TAG_Compound({}), 'a': TAG_Compound({})})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])})),
            "TAG_Compound({'key': TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(
                TAG_Compound(
                    {
                        "b": TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3]),
                        "a": TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3]),
                    }
                )
            ),
            "TAG_Compound({'b': TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3]), 'a': TAG_Int_Array([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(TAG_Compound({"key": TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])})),
            "TAG_Compound({'key': TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])})",
        )
        self.assertEqual(
            repr(
                TAG_Compound(
                    {
                        "b": TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3]),
                        "a": TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3]),
                    }
                )
            ),
            "TAG_Compound({'b': TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3]), 'a': TAG_Long_Array([-3, -2, -1, 0, 1, 2, 3])})",
        )


if __name__ == "__main__":
    unittest.main()
