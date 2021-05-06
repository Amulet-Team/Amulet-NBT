import unittest
import numpy
import os
import amulet_nbt.amulet_nbt_py as pynbt

try:
    import amulet_nbt.amulet_cy_nbt as cynbt
except (ImportError, ModuleNotFoundError) as e:
    cynbt = None


class AbstractNBTTest:
    class MassiveNBTTests(unittest.TestCase):
        def _setUp(self, nbt_library):
            self.maxDiff = None
            self.nbt = nbt_library

        def test_api(self):
            test_ = self.nbt.NBTFile(self.nbt.TAG_Compound(), name="hello")

            test = self.nbt.NBTFile(
                name="hello"
            )  # fill with an empty compound if not defined

            # the nbt objects with no inputs
            test["emptyByte"] = self.nbt.TAG_Byte()
            test["emptyShort"] = self.nbt.TAG_Short()
            test["emptyInt"] = self.nbt.TAG_Int()
            test["emptyLong"] = self.nbt.TAG_Long()
            test["emptyFloat"] = self.nbt.TAG_Float()
            test["emptyDouble"] = self.nbt.TAG_Double()
            test["emptyByteArray"] = self.nbt.TAG_Byte_Array()
            test["emptyString"] = self.nbt.TAG_String()
            test["emptyList"] = self.nbt.TAG_List()
            test["emptyCompound"] = self.nbt.TAG_Compound()
            test["emptyIntArray"] = self.nbt.TAG_Int_Array()
            test["emptyLongArray"] = self.nbt.TAG_Long_Array()

            # the nbt objects with zero or empty inputs (pure python only)
            test["zeroByte"] = self.nbt.TAG_Byte(0)
            test["zeroShort"] = self.nbt.TAG_Short(0)
            test["zeroInt"] = self.nbt.TAG_Int(0)
            test["zeroLong"] = self.nbt.TAG_Long(0)
            test["zeroFloat"] = self.nbt.TAG_Float(0)
            test["zeroDouble"] = self.nbt.TAG_Double(0)
            test["zeroByteArray"] = self.nbt.TAG_Byte_Array([])
            test["zeroString"] = self.nbt.TAG_String("")
            test["zeroList"] = self.nbt.TAG_List([])
            test["zeroCompound"] = self.nbt.TAG_Compound({})
            test["zeroIntArray"] = self.nbt.TAG_Int_Array([])
            test["zeroLongArray"] = self.nbt.TAG_Long_Array([])

            # empty inputs but numpy arrays for the array types
            test["zeroNumpyByteArray"] = self.nbt.TAG_Byte_Array(numpy.array([]))
            test["zeroNumpyIntArray"] = self.nbt.TAG_Int_Array(numpy.array([]))
            test["zeroNumpyLongArray"] = self.nbt.TAG_Long_Array(numpy.array([]))

            # test the array types with some python data
            test["listByteArray"] = self.nbt.TAG_Byte_Array(
                [i for i in range(-128, 127)]
            )
            test["listIntArray"] = self.nbt.TAG_Int_Array([i for i in range(-400, 400)])
            test["listLongArray"] = self.nbt.TAG_Long_Array(
                [i for i in range(-400, 400)]
            )

            # test the array types with numpy data of varying dtypes
            test["numpyDtypeTestByteArray"] = self.nbt.TAG_Byte_Array(
                numpy.array([i for i in range(-128, 127)], dtype=int)
            )
            test["numpyDtypeuTestByteArray"] = self.nbt.TAG_Byte_Array(
                numpy.array([i for i in range(-128, 127)], dtype=numpy.uint)
            )
            test["numpyDtypeTestIntArray"] = self.nbt.TAG_Int_Array(
                numpy.array([i for i in range(-400, 400)], dtype=int)
            )
            test["numpyDtypeuTestIntArray"] = self.nbt.TAG_Int_Array(
                numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
            )
            test["numpyDtypeTestLongArray"] = self.nbt.TAG_Long_Array(
                numpy.array([i for i in range(-400, 400)], dtype=int)
            )
            test["numpyDtypeuTestLongArray"] = self.nbt.TAG_Long_Array(
                numpy.array([i for i in range(-400, 400)], dtype=numpy.uint)
            )

            test["numpyDtypedTestByteArray"] = self.nbt.TAG_Byte_Array(
                numpy.array([i for i in range(-128, 127)])
            )
            test["numpyDtypedTestIntArray"] = self.nbt.TAG_Int_Array(
                numpy.array([i for i in range(-400, 400)])
            )
            test["numpyDtypedTestLongArray"] = self.nbt.TAG_Long_Array(
                numpy.array([i for i in range(-400, 400)])
            )

            # test the extremes of the array types
            # byte array tested above
            test["numpyExtremeTestIntArray"] = self.nbt.TAG_Int_Array(
                numpy.array([-(2 ** 31), (2 ** 31) - 1], dtype=int)
            )
            test["numpyExtremeTestLongArray"] = self.nbt.TAG_Long_Array(
                numpy.array([-(2 ** 63), (2 ** 63) - 1], dtype="q")
            )

            test["minByte"] = self.nbt.TAG_Byte(-128)
            test["minShort"] = self.nbt.TAG_Short(-(2 ** 15))
            test["minInt"] = self.nbt.TAG_Int(-(2 ** 31))
            test["minLong"] = self.nbt.TAG_Long(-(2 ** 63))

            test["maxByte"] = self.nbt.TAG_Byte(127)
            test["maxShort"] = self.nbt.TAG_Short(2 ** 15 - 1)
            test["maxInt"] = self.nbt.TAG_Int(2 ** 31 - 1)
            test["maxLong"] = self.nbt.TAG_Long(2 ** 63 - 1)

            # these should either overflow when setting or error when saving. Test each and if it errors just comment it out
            # test['overflowByte'] = self.nbt.TAG_Byte(300)
            # test['underflowByte'] = self.nbt.TAG_Byte(-300)
            # test['overflowShort'] = self.nbt.TAG_Short(2**16)
            # test['underflowShort'] = self.nbt.TAG_Short(-2**16)
            # test['overflowInt'] = self.nbt.TAG_Int(2**32)
            # test['underflowInt'] = self.nbt.TAG_Int(-2**32)
            # test['overflowLong'] = self.nbt.TAG_Long(2**64)
            # test['underflowLong'] = self.nbt.TAG_Long(-2**64)

            # test['overflowByteArray'] = self.nbt.TAG_Byte_Array([-129, 128])
            # test['overflowIntArray'] = self.nbt.TAG_Int_Array([-2**31-1, 2**31])
            # test['overflowLongArray'] = self.nbt.TAG_Long_Array([-2**63-1, 2**63])

            # test['overflowNumpyByteArray'] = self.nbt.TAG_Byte_Array(numpy.array([-129, 128]))
            # test['overflowNumpyIntArray'] = self.nbt.TAG_Int_Array(numpy.array([-2**31-1, 2**31]))
            # test['overflowNumpyLongArray'] = self.nbt.TAG_Long_Array(numpy.array([-2**63-1, 2**63]))

            # save then load back up and check the data matches

            os.makedirs("temp", exist_ok=True)
            test.save_to(
                os.path.join("temp", "massive_nbt_test_big_endian.nbt"),
                compressed=False,
            )
            test.save_to(
                os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt"),
                compressed=True,
            )
            test.save_to(
                os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
                compressed=False,
                little_endian=True,
            )

            test_be = self.nbt.load(
                os.path.join("temp", "massive_nbt_test_big_endian.nbt")
            )
            test_be_compressed = self.nbt.load(
                os.path.join("temp", "massive_nbt_test_big_endian_compressed.nbt")
            )
            test_le = self.nbt.load(
                os.path.join("temp", "massive_nbt_test_little_endian.nbt"),
                little_endian=True,
            )

            assert test_be == test
            assert test_be_compressed == test
            assert test_le == test


@unittest.skipUnless(cynbt, "Cythonized library not available")
class CythonMassiveNBTTest(AbstractNBTTest.MassiveNBTTests):
    def setUp(self):
        self._setUp(cynbt)


class PythonMassiveNBTTest(AbstractNBTTest.MassiveNBTTests):
    def setUp(self):
        self._setUp(pynbt)


if __name__ == "__main__":
    unittest.main()
