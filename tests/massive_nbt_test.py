import amulet_nbt
import numpy

test = amulet_nbt.NBTFile(name='hello')  # fill with an empty compound if not defined

# the nbt objects with no inputs
test['emptyByte'] = amulet_nbt.TAG_Byte()
test['emptyShort'] = amulet_nbt.TAG_Short()
test['emptyInt'] = amulet_nbt.TAG_Int()
test['emptyLong'] = amulet_nbt.TAG_Long()
test['emptyFloat'] = amulet_nbt.TAG_Float()
test['emptyDouble'] = amulet_nbt.TAG_Double()
test['emptyByteArray'] = amulet_nbt.TAG_Byte_Array()
test['emptyString'] = amulet_nbt.TAG_String()
test['emptyList'] = amulet_nbt.TAG_List()
test['emptyCompound'] = amulet_nbt.TAG_Compound()
test['emptyIntArray'] = amulet_nbt.TAG_Int_Array()
test['emptyLongArray'] = amulet_nbt.TAG_Long_Array()

# the nbt objects with zero or empty inputs (pure python only)
test['zeroByte'] = amulet_nbt.TAG_Byte(0)
test['zeroShort'] = amulet_nbt.TAG_Short(0)
test['zeroInt'] = amulet_nbt.TAG_Int(0)
test['zeroLong'] = amulet_nbt.TAG_Long(0)
test['zeroFloat'] = amulet_nbt.TAG_Float(0)
test['zeroDouble'] = amulet_nbt.TAG_Double(0)
test['zeroByteArray'] = amulet_nbt.TAG_Byte_Array([])
test['zeroString'] = amulet_nbt.TAG_String('')
test['zeroList'] = amulet_nbt.TAG_List([])
test['zeroCompound'] = amulet_nbt.TAG_Compound({})
test['zeroIntArray'] = amulet_nbt.TAG_Int_Array([])
test['zeroLongArray'] = amulet_nbt.TAG_Long_Array([])

# empty inputs but numpy arrays for the array types
test['zeroNumpyByteArray'] = amulet_nbt.TAG_Byte_Array(numpy.array([]))
test['zeroNumpyIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([]))
test['zeroNumpyLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([]))

# test the array types with some python data
test['listByteArray'] = amulet_nbt.TAG_Byte_Array([i for i in range(-128, 127)])
test['listIntArray'] = amulet_nbt.TAG_Int_Array([i for i in range(-400, 400)])
test['listLongArray'] = amulet_nbt.TAG_Long_Array([i for i in range(-400, 400)])

# test the array types with numpy data of varying dtypes
test['numpyDtypeTestByteArray'] = amulet_nbt.TAG_Byte_Array(numpy.array([i for i in range(-128, 127)], dtype=numpy.int))
test['numpyDtypeuTestByteArray'] = amulet_nbt.TAG_Byte_Array(numpy.array([i for i in range(-128, 127)], dtype=numpy.uint))
test['numpyDtypeTestIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([i for i in range(-400, 400)], dtype=numpy.int))
test['numpyDtypeuTestIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([i for i in range(-400, 400)], dtype=numpy.uint))
test['numpyDtypeTestLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([i for i in range(-400, 400)], dtype=numpy.int))
test['numpyDtypeuTestLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([i for i in range(-400, 400)], dtype=numpy.uint))

test['numpyDtypedTestByteArray'] = amulet_nbt.TAG_Byte_Array(numpy.array([i for i in range(-128, 127)]))
test['numpyDtypedTestIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([i for i in range(-400, 400)]))
test['numpyDtypedTestLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([i for i in range(-400, 400)]))

# test the extremes of the array types
# byte array tested above
test['numpyExtremeTestIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([-2**31, (2**31)-1], dtype=numpy.int))
test['numpyExtremeTestLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([-2**63, (2**63)-1], dtype=numpy.int))

test['minByte'] = amulet_nbt.TAG_Byte(-128)
test['minShort'] = amulet_nbt.TAG_Short(-2**15)
test['minInt'] = amulet_nbt.TAG_Int(-2**31)
test['minLong'] = amulet_nbt.TAG_Long(-2**63)

test['maxByte'] = amulet_nbt.TAG_Byte(127)
test['maxShort'] = amulet_nbt.TAG_Short(2**15-1)
test['maxInt'] = amulet_nbt.TAG_Int(2**31-1)
test['maxLong'] = amulet_nbt.TAG_Long(2**64-1)


# these should either overflow when setting or error when saving. Test each and if it errors just comment it out
test['overflowByte'] = amulet_nbt.TAG_Byte(300)
test['underflowByte'] = amulet_nbt.TAG_Byte(-300)
test['overflowShort'] = amulet_nbt.TAG_Short(2**16)
test['underflowShort'] = amulet_nbt.TAG_Short(-2**16)
test['overflowInt'] = amulet_nbt.TAG_Int(2**32)
test['underflowInt'] = amulet_nbt.TAG_Int(-2**32)
test['overflowLong'] = amulet_nbt.TAG_Long(2**64)
test['underflowLong'] = amulet_nbt.TAG_Long(-2**64)

test['overflowByteArray'] = amulet_nbt.TAG_Byte_Array([-129, 128])
test['overflowIntArray'] = amulet_nbt.TAG_Int_Array([-2**31-1, 2**31])
test['overflowLongArray'] = amulet_nbt.TAG_Long_Array([-2**63-1, 2**63])

test['overflowNumpyByteArray'] = amulet_nbt.TAG_Byte_Array(numpy.array([-129, 128]))
test['overflowNumpyIntArray'] = amulet_nbt.TAG_Int_Array(numpy.array([-2**31-1, 2**31]))
test['overflowNumpyLongArray'] = amulet_nbt.TAG_Long_Array(numpy.array([-2**63-1, 2**63]))


# save then load back up and check the data matches

test.save_to('massive_nbt_test_big_endian.nbt', compressed=False)
test.save_to('massive_nbt_test_big_endian_compressed.nbt', compressed=True)
test.save_to('massive_nbt_test_little_endian.nbt', compressed=False, little_endian=True)

test_be = amulet_nbt.load('massive_nbt_test_big_endian.nbt')
test_be_compressed = amulet_nbt.load('massive_nbt_test_big_endian_compressed.nbt')
test_le = amulet_nbt.load('massive_nbt_test_little_endian.nbt', little_endian=True)

assert test_be == test
assert test_be_compressed == test
assert test_le == test