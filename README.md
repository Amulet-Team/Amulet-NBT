# Amulet-NBT

amulet_nbt is a Python 3 library for reading and writing both binary NBT and SNBT (stringified-NBT in the format used in Java commands)

## Usage
It is suggested to first build the cython verion but there is a pure python version as backup but it is considerably slower.



```python
# This will try importing the cython version and fall back to the pure python version
import amulet_nbt

# Load binary NBT
nbt_obj = amulet_nbt.load('filepath')  # from a file
amulet_nbt.load(buffer=b'<nbt file bytes>')  # from a bytes object (only use one of these two at a time)

# optional arguments for load
# compressed=False  # is the nbt data compressed using gzip
# count=5  # read a sequence of binary NBT objects and return them all. If defined returns a list of NBTFile objects otherwise just returns an NBTFile
# offset=True  # read an NBT object and also return the end byte offset. False by default
# little_endian=True  # read a binary NBT object in little endian foramt, as used in Bedrock. False by default

nbt_obj: amulet_nbt.NBTFile
nbt_obj.save_to('filepath')
with open('filepath', 'wb') as f:
  nb_obj.save_to(f)
# optional arguments for save_to
# compressed=bool # should the bindary data be compressed using gzip
# little_endian=bool # should the binary data be saved in little endian format

nbt_obj = amulet_nbt.from_snbt('{key1: "value", key2: 0b, key3: 0.0f}')
# nbt_obj should look like this
# TAG_Compound(
#    key1: TAG_String("value"),
#    key2: TAG_Byte(0)
#    key3: TAG_Float(0.0)
)
amulet_nbt.NBTFile(nbt_obj).save_to('filepath') # binary NBT has extra data that is lost in SNBT so you need to do this to add that data back in
amulet_nbt.NBTFile(nbt_obj).to_snbt() # convert back to SNBT
nbt_obj.to_snbt() # this does the same as the above

# create NBT objects from scratch
nbt_obj = amulet_nbt.NBTFile(  # everthing should be wrapped in this class
	amulet_nbt.TAG_Compound({
		"key1": amulet_nbt.TAG_Byte(0)  # if no input value is given it will automatically fill these defaults
		"key2": amulet_nbt.TAG_Short(0)
		"key3": amulet_nbt.TAG_Int(0)
		"key4": amulet_nbt.TAG_Long(0)
		"key5": amulet_nbt.TAG_Float(0.0)
		"key6": amulet_nbt.TAG_Double(0.0)
		"key7": amulet_nbt.TAG_Byte_Array([])
		"key8": amulet_nbt.TAG_String("")
		"key9": amulet_nbt.TAG_List([])
		"key10": amulet_nbt.TAG_Compound({})
		"key11": amulet_nbt.TAG_Int_Array([])
		"key12": amulet_nbt.TAG_Long_Array([])
	})
	
)
```

## Cython
To build the cython version you will first need to install the requirements in requirements.txt using something like pip

run this command to build which should create a amulet_cy_nbt.___.pyd file

`python -m setup.py build_ext --inplace`
