import unittest
import numpy
import os
import amulet_nbt


class MassiveNBTTests(unittest.TestCase):
    def test_api(self):
        compound = amulet_nbt.TAG_Compound()
        nbt_file = amulet_nbt.NBTFile(compound, name="hello")

        # the nbt objects with no inputs
        compound["emptyByte"] = amulet_nbt.TAG_Byte()
        compound["emptyShort"] = amulet_nbt.TAG_Short()
        compound["emptyInt"] = amulet_nbt.TAG_Int()
        compound["emptyLong"] = amulet_nbt.TAG_Long()
        compound["emptyFloat"] = amulet_nbt.TAG_Float()
        compound["emptyDouble"] = amulet_nbt.TAG_Double()
        compound["emptyByteArray"] = amulet_nbt.TAG_Byte_Array()
        compound["emptyString"] = amulet_nbt.TAG_String()
        compound["emptyList"] = amulet_nbt.TAG_List()
        compound["emptyCompound"] = amulet_nbt.TAG_Compound()
        compound["emptyIntArray"] = amulet_nbt.TAG_Int_Array()
        compound["emptyLongArray"] = amulet_nbt.TAG_Long_Array()

        # the nbt objects with zero or empty inputs (pure python only)
        compound["zeroByte"] = amulet_nbt.TAG_Byte(0)
        compound["zeroShort"] = amulet_nbt.TAG_Short(0)
        compound["zeroInt"] = amulet_nbt.TAG_Int(0)
        compound["zeroLong"] = amulet_nbt.TAG_Long(0)
        compound["zeroFloat"] = amulet_nbt.TAG_Float(0)
        compound["zeroDouble"] = amulet_nbt.TAG_Double(0)
        compound["zeroByteArray"] = amulet_nbt.TAG_Byte_Array([])
        compound["zeroString"] = amulet_nbt.TAG_String("")
        compound["zeroList"] = amulet_nbt.TAG_List([])
        compound["zeroCompound"] = amulet_nbt.TAG_Compound({})
        compound["zeroIntArray"] = amulet_nbt.TAG_Int_Array([])
        compound["zeroLongArray"] = amulet_nbt.TAG_Long_Array([])

        # empty inputs but numpy arrays for the array types
        compound["zeroNumpyByteArray"] = amulet_nbt.TAG_Byte_Array(numpy.array([]))
        compound["zeroNumpyIntArray"] = amulet_nbt.TAG_Int_Array(numpy.array([]))
        compound["zeroNumpyLongArray"] = amulet_nbt.TAG_Long_Array(numpy.array([]))

        # test the array types with some python data
        compound["listByteArray"] = amulet_nbt.TAG_Byte_Array([i for i in range(-128, 127)])
        compound["listIntArray"] = amulet_nbt.TAG_Int_Array([i for i in range(-400, 400)])
        compound["listLongArray"] = amulet_nbt.TAG_Long_Array([i for i in range(-400, 400)])

        # test the array types with numpy data of varying dtypes
        compound["numpyDtypeTestByteArray"] = amulet_nbt.TAG_Byte_Array(
            numpy.array([i for i in range(-128, 127)], dtype=int)
        )
        compound["numpyDtypeuTestByteArray"] = amulet_nbt.TAG_Byte_Array(
            numpy.array([i for i in range(-128, 127)], dtype=numpy.uint)
        )
        compound["numpyDtypeTestIntArray"] = amulet_nbt.TAG_Int_Array(
            numpy.array([i for i in range(-400, 400)], dtype=int)
        )
        compound["numpyDtypeuTestIntArray"] = amulet_nbt.TAG_Int_Array(
            numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
        )
        compound["numpyDtypeTestLongArray"] = amulet_nbt.TAG_Long_Array(
            numpy.array([i for i in range(-400, 400)], dtype=int)
        )
        compound["numpyDtypeuTestLongArray"] = amulet_nbt.TAG_Long_Array(
            numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
        )

        compound["numpyDtypedTestByteArray"] = amulet_nbt.TAG_Byte_Array(
            numpy.array([i for i in range(-128, 127)])
        )
        compound["numpyDtypedTestIntArray"] = amulet_nbt.TAG_Int_Array(
            numpy.array([i for i in range(-400, 400)])
        )
        compound["numpyDtypedTestLongArray"] = amulet_nbt.TAG_Long_Array(
            numpy.array([i for i in range(-400, 400)])
        )

        # test the extremes of the array types
        # byte array tested above
        compound["numpyExtremeTestIntArray"] = amulet_nbt.TAG_Int_Array(
            numpy.array([-(2 ** 31), (2 ** 31) - 1], dtype=int)
        )
        compound["numpyExtremeTestLongArray"] = amulet_nbt.TAG_Long_Array(
            numpy.array([-(2 ** 63), (2 ** 63) - 1], dtype="q")
        )

        compound["minByte"] = amulet_nbt.TAG_Byte(-128)
        compound["minShort"] = amulet_nbt.TAG_Short(-(2 ** 15))
        compound["minInt"] = amulet_nbt.TAG_Int(-(2 ** 31))
        compound["minLong"] = amulet_nbt.TAG_Long(-(2 ** 63))

        compound["maxByte"] = amulet_nbt.TAG_Byte(127)
        compound["maxShort"] = amulet_nbt.TAG_Short(2 ** 15 - 1)
        compound["maxInt"] = amulet_nbt.TAG_Int(2 ** 31 - 1)
        compound["maxLong"] = amulet_nbt.TAG_Long(2 ** 63 - 1)

        # these should either overflow when setting or error when saving. Test each and if it errors just comment it out
        compound['overflowByte'] = amulet_nbt.TAG_Byte(300)
        compound['underflowByte'] = amulet_nbt.TAG_Byte(-300)
        compound['overflowShort'] = amulet_nbt.TAG_Short(2**16)
        compound['underflowShort'] = amulet_nbt.TAG_Short(-2**16)
        compound['overflowInt'] = amulet_nbt.TAG_Int(2**32)
        compound['underflowInt'] = amulet_nbt.TAG_Int(-2**32)
        compound['overflowLong'] = amulet_nbt.TAG_Long(2**64)
        compound['underflowLong'] = amulet_nbt.TAG_Long(-2**64)

        # compound['overflowByteArray'] = amulet_nbt.TAG_Byte_Array([-129, 128])
        # compound['overflowIntArray'] = amulet_nbt.TAG_Int_Array([-2**31-1, 2**31])
        # compound['overflowLongArray'] = amulet_nbt.TAG_Long_Array([-2**63-1, 2**63])

        # compound['overflowNumpyByteArray'] = amulet_nbt.TAG_Byte_Array(numpy.array([-129, 128]))
        # compound['overflowNumpyIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([-2**31-1, 2**31]))
        # compound['overflowNumpyLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([-2**63-1, 2**63]))

        # save then load back up and check the data matches

        os.makedirs("temp", exist_ok=True)
        nbt_file.save_to(
            os.path.join("temp", "massive_nbt_test_big_endian.nbt"),
            compressed=False,
        )
        nbt_file.save_to(
            os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt"),
            compressed=True,
        )
        nbt_file.save_to(
            os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
            compressed=False,
            little_endian=True,
        )

        test_be = amulet_nbt.load(
            os.path.join("temp", "massive_nbt_test_big_endian.nbt")
        )
        test_be_compressed = amulet_nbt.load(
            os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt")
        )
        test_le = amulet_nbt.load(
            os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
            little_endian=True,
        )

        self.assertEqual(test_be, nbt_file)
        self.assertEqual(test_be_compressed, nbt_file)
        self.assertEqual(test_le, nbt_file)


if __name__ == "__main__":
    unittest.main()
