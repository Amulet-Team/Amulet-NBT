# import unittest
# import numpy
#
# from amulet_nbt import (
#     TAG_Byte,
#     TAG_Short,
#     TAG_Int,
#     TAG_Long,
#     TAG_Float,
#     TAG_Double,
#     TAG_Byte_Array,
#     TAG_Int_Array,
#     TAG_Long_Array,
#     TAG_String,
#     TAG_List,
#     TAG_Compound,
# )
#
#
# class NBTTests(unittest.TestCase):
#
#
#     def test_init(self):
#         for inp in (
#             5,
#             TAG_Byte(5),
#             TAG_Short(5),
#             TAG_Int(5),
#             TAG_Long(5),
#             5.5,
#             TAG_Float(5.5),
#             TAG_Double(5.5),
#         ):
#             for nbt_type in self._int_types:
#                 self.assertIsInstance(nbt_type(inp).value, int)
#                 self.assertEqual(nbt_type(inp), 5)
#             for nbt_type in self._float_types:
#                 self.assertIsInstance(nbt_type(inp).value, float)
#                 if inp == 5:
#                     self.assertEqual(nbt_type(inp), 5)
#                 else:
#                     self.assertEqual(nbt_type(inp), 5.5)
#
#         TAG_String(TAG_String())
#         TAG_List(TAG_List())
#         TAG_Compound(TAG_Compound())
#
#         TAG_Byte_Array(TAG_Byte_Array())
#         TAG_Int_Array(TAG_Int_Array())
#         TAG_Long_Array(TAG_Long_Array())
#
#
# if __name__ == "__main__":
#     unittest.main()
