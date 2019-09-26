import gzip
import zlib
from collections.abc import MutableMapping, MutableSequence
from io import BytesIO
from typing import Optional, Union

import numpy
from cpython cimport PyUnicode_DecodeUTF8, PyList_Append

cdef char _ID_END = 0
cdef char _ID_BYTE = 1
cdef char _ID_SHORT = 2
cdef char _ID_INT = 3
cdef char _ID_LONG = 4
cdef char _ID_FLOAT = 5
cdef char _ID_DOUBLE = 6
cdef char _ID_BYTE_ARRAY = 7
cdef char _ID_STRING = 8
cdef char _ID_LIST = 9
cdef char _ID_COMPOUND = 10
cdef char _ID_INT_ARRAY = 11
cdef char _ID_LONG_ARRAY = 12
cdef char _ID_MAX = 13

ID_END = _ID_END
ID_BYTE = _ID_BYTE
ID_SHORT = _ID_SHORT
ID_INT = _ID_INT
ID_LONG = _ID_LONG
ID_FLOAT = _ID_FLOAT
ID_DOUBLE = _ID_DOUBLE
ID_BYTE_ARRAY = _ID_BYTE_ARRAY
ID_STRING = _ID_STRING
ID_LIST = _ID_LIST
ID_COMPOUND = _ID_COMPOUND
ID_INT_ARRAY = _ID_INT_ARRAY
ID_LONG_ARRAY = _ID_LONG_ARRAY
ID_MAX = _ID_MAX

NBT_WRAPPER = "amulet"

cpdef dict TAG_CLASSES = {
    ID_BYTE: TAG_Byte,
    ID_SHORT: TAG_Short,
    ID_INT: TAG_Int,
    ID_LONG: TAG_Long,
    ID_FLOAT: TAG_Float,
    ID_DOUBLE: TAG_Double,
    ID_BYTE_ARRAY: TAG_Byte_Array,
    ID_STRING: TAG_String,
    ID_LIST: _TAG_List,
    ID_COMPOUND: _TAG_Compound,
    ID_INT_ARRAY: TAG_Int_Array,
    ID_LONG_ARRAY: TAG_Long_Array
}

USE_BIG_ENDIAN = 1

# Utility Methods
class NBTFormatError(ValueError):
    """Indicates the NBT format is invalid."""
    pass

cdef class buffer_context:
    cdef size_t offset
    cdef char * buffer
    cdef size_t size

cdef char * read_data(buffer_context context, size_t tag_size) except NULL:
    if tag_size > context.size - context.offset:
        raise NBTFormatError(
            f"NBT Stream too short. Asked for {tag_size:d}, only had {(context.size - context.offset):d}")

    cdef char* value = context.buffer + context.offset
    context.offset += tag_size
    return value

cdef void to_little_endian(void * data_buffer, int num_bytes):

    if not USE_BIG_ENDIAN:
        return

    cdef unsigned char * buf = <unsigned char *> data_buffer
    cdef int i

    for i in range((num_bytes + 1) // 2):
        buf[i], buf[num_bytes - i - 1] = buf[num_bytes - i - 1], buf[i]

cdef str load_name(buffer_context context):
    cdef unsigned short * pointer = <unsigned short *> read_data(context, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2)
    b = read_data(context, length)

    return PyUnicode_DecodeUTF8(b, length, "strict")

cdef tuple load_named(buffer_context context, char tagID):
    cdef str name = load_name(context)
    cdef _TAG_Value tag = load_tag(tagID, context)
    return name, tag

cdef _TAG_Value load_tag(char tagID, buffer_context context):
    if tagID == _ID_BYTE:
        return load_byte(context)

    if tagID == _ID_SHORT:
        return load_short(context)

    if tagID == _ID_INT:
        return load_int(context)

    if tagID == _ID_LONG:
        return load_long(context)

    if tagID == _ID_FLOAT:
        return load_float(context)

    if tagID == _ID_DOUBLE:
        return load_double(context)

    if tagID == _ID_BYTE_ARRAY:
        return load_byte_array(context)

    if tagID == _ID_STRING:
        return TAG_String(load_string(context))

    if tagID == _ID_LIST:
        return load_list(context)

    if tagID == _ID_COMPOUND:
        return load_compound_tag(context)

    if tagID == _ID_INT_ARRAY:
        return load_int_array(context)

    if tagID == _ID_LONG_ARRAY:
        return load_long_array(context)

cpdef bytes safe_gunzip(bytes data):
    try:
        data = gzip.GzipFile(fileobj=BytesIO(data)).read()
    except (IOError, zlib.error) as e:
        pass
    return data


cdef class _TAG_Value:
    cdef public char tag_id

    def copy(self):
        return self.__class__(self.value)

    cpdef str to_snbt(self):
        raise NotImplementedError()

    cdef void save_value(self, buffer):
        raise NotImplementedError()

cdef class TAG_Byte(_TAG_Value):
    cdef public char value

    def __cinit__(self):
        self.tag_id = _ID_BYTE

    def __init__(self, char value = 0):
        self.value = value

    cpdef str to_snbt(self):
        return f"{self.value}b"

    cdef void save_value(self, buffer):
        save_byte(self.value, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value


cdef class TAG_Short(_TAG_Value):
    cdef public short value

    def __cinit__(self):
        self.tag_id = _ID_SHORT

    def __init__(self, short value = 0):
        self.value = value

    cpdef str to_snbt(self):
        return f"{self.value}s"

    cdef void save_value(self, buffer):
        save_short(self.value, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

cdef class TAG_Int(_TAG_Value):
    cdef public int value

    def __cinit__(self):
        self.tag_id = _ID_INT

    def __init__(self, int value = 0):
        self.value = value

    cpdef str to_snbt(self):
        return f"{self.value}"

    cdef void save_value(self, buffer):
        save_int(self.value, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

cdef class TAG_Long(_TAG_Value):
    cdef public long long value

    def __cinit__(self):
        self.tag_id = _ID_LONG

    def __init__(self, long long value = 0):
        self.value = value

    cpdef str to_snbt(self):
        return f"{self.value}l"

    cdef void save_value(self, buffer):
        save_long(self.value, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

cdef class TAG_Float(_TAG_Value):
    cdef public float value

    def __cinit__(self):
        self.tag_id = _ID_FLOAT

    def __init__(self, float value = 0):
        self.value = value

    cpdef str to_snbt(self):
        return f"{self.value}f"

    cdef void save_value(self, buffer):
        save_float(self.value, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

cdef class TAG_Double(_TAG_Value):
    cdef public double value

    def __cinit__(self):
        self.tag_id = _ID_DOUBLE

    def __init__(self, double value = 0):
        self.value = value

    cpdef str to_snbt(self):
        return f"{self.value}d"

    cdef void save_value(self, buffer):
        save_double(self.value, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

def escape(string: str):
    return string.replace('\\', '\\\\').replace('"', '\\"')

cdef class TAG_String(_TAG_Value):
    cdef public unicode value

    def __cinit__(self):
        self.tag_id = _ID_STRING

    def __init__(self, unicode value = ""):
        self.value = value

    def __len__(self) -> int:
        return len(self.value)

    cpdef str to_snbt(self):
        return f"\"{escape(self.value)}\""

    cdef void save_value(self, buffer):
        save_string(self.value.encode("utf-8"), buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

cdef class _TAG_Array(_TAG_Value):
    cdef public object value

    def __eq__(self, other: _TAG_Array) -> bool:
        return isinstance(other, self.__class__) and self.tag_id == other.tag_id and numpy.array_equal(self.value, other.value)

    def __len__(self):
        return len(self.value)

cdef class TAG_Byte_Array(_TAG_Array):
    data_type = numpy.dtype("u1")

    def __cinit__(self):
        self.tag_id = _ID_BYTE_ARRAY

    def __init__(self, object value = None):
        if value is None:
            value = numpy.zeros((0,), self.data_type)

        self.value = value

    cpdef str to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value:
            tags.append(str(elem))
        return f"[B;{', '.join(tags)}]"

    cdef void save_value(self, buffer):
        save_array(self.value, buffer, 1)

cdef class TAG_Int_Array(_TAG_Value):
    data_type = numpy.dtype(">u4")

    def __cinit__(self):
        self.tag_id = _ID_INT_ARRAY

    def __init__(self, object value = None):
        if value is None:
            value = numpy.zeros((0,), self.data_type)

        self.value = value

    cpdef str to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value:
            tags.append(str(elem))
        return f"[I;{', '.join(tags)}]"

    cdef void save_value(self, buffer):
        save_array(self.value, buffer, 4)

cdef class TAG_Long_Array(_TAG_Value):
    data_type = numpy.dtype(">q")

    def __cinit__(self):
        self.tag_id = _ID_LONG_ARRAY

    def __init__(self, object value = None):
        if value is None:
            value = numpy.zeros((0,), self.data_type)

        self.value = value

    cpdef str to_snbt(self):
        cdef int elem
        cdef list tags = []
        for elem in self.value:
            tags.append(str(elem))
        return f"[L;{', '.join(tags)}]"

    cdef void save_value(self, buffer):
        save_array(self.value, buffer, 8)

cdef class _TAG_List(_TAG_Value):
    cdef public list value
    cdef char list_data_type

    def __cinit__(self):
        self.tag_id = _ID_LIST

    def __init__(self, list value = None, char list_data_type = 1):
        self.value = []
        self.list_data_type = list_data_type

        if value:
            self.list_data_type = value[0].tag_id
            map(self.check_tag, value)
            self.value = list(value)

    cpdef str to_snbt(self):
        cdef _TAG_Value elem
        cdef list tags = []
        for elem in self.value:
            tags.append(elem.to_snbt())
        return f"[{', '.join(tags)}]"

    def check_tag(self, value):
        if value.tagID != self.list_data_type:
            raise TypeError("Invalid type %s for TAG_List(%s)" % (value.__class__, TAG_CLASSES[self.list_data_type]))

    def __getitem__(self, index: int) -> _TAG_Value:
        return self.value[index]

    def __setitem__(self, index: Union[int, slice], value: _TAG_Value):
        if isinstance(index, slice):
            for tag in value:
                self.check_tag(tag)
        else:
            self.check_tag(value)
        self.value[index] = value

    def __iter__(self):
        return iter(self.value)

    def __len__(self) -> int:
        return len(self.value)

    def insert(self, index: int, tag: _TAG_Value):
        if len(self.value) == 0:
            self.list_data_type = tag.tag_id
        else:
            self.check_tag(tag)

        self.value.insert(index, tag)

    def __delitem__(self, key: int):
        del self.value[key]

    cdef void save_value(self, buffer):
        cdef char list_type = self.list_data_type

        save_tag_id(list_type, buffer)
        save_int(<int>len(self.value), buffer)

        cdef _TAG_Value subtag
        for subtag in self.value:
            if subtag.tag_id != list_type:
                raise ValueError("Asked to save TAG_List with different types! Found %s and %s" % (subtag.tag_id,
                                                                                                   list_type))
            save_tag_value(subtag, buffer)

    def __eq__(self, other) -> bool:
        return isinstance(other, self.__class__) and self.value == other.value

class TAG_List(_TAG_List, MutableSequence):
    pass

cdef class _TAG_Compound(_TAG_Value):
    cdef public dict value

    def __cinit__(self):
        self.tag_id = _ID_COMPOUND

    def __init__(self, dict value = None):
        self.value = value or {}

    cpdef str to_snbt(self):
        cdef str k
        cdef _TAG_Value v
        cdef list tags = []
        for k, v in self.value.items():
            tags.append(f"{k}: {v.to_snbt()}")
        return f"{{{', '.join(tags)}}}"

    cdef void save_value(self, buffer):
        cdef str key
        cdef _TAG_Value stag

        for key, stag in self.value.items():
            save_tag_id(stag.tag_id, buffer)
            save_tag_name(key, buffer)
            stag.save_value(buffer)
        save_tag_id(_ID_END, buffer)

    def save(self, buffer, name=""):
        save_tag_id(self.tag_id, buffer)
        save_tag_name(name, buffer)
        save_tag_value(self, buffer)

    def __getitem__(self, key: str) -> _TAG_Value:
        return self.value[key]

    def __setitem__(self, key: str, tag: _TAG_Value):
        self.value[key] = tag

    def __delitem__(self, key: str):
        del self.value[key]

    def __iter__(self):
        yield from self.value

    def __contains__(self, key: str) -> bool:
        return key in self.value

    def __len__(self) -> int:
        return self.value.__len__()

    def __eq__(self, other) -> bool:
        return self.value.__eq__(other.value)

class TAG_Compound(_TAG_Compound, MutableMapping):
    pass

class NBTFile(MutableMapping):

    def __init__(self, tag, str name=""):
        self.value = tag
        self.name = name

    def to_snbt(self) -> str:
        return self.value.to_snbt()

    def save_to(self, filename_or_buffer=None, compressed=True) -> Optional[BytesIO]:
        buffer = BytesIO()
        self.value.save(buffer, self.name)
        data = buffer.getvalue()

        if compressed:
            gzip_buffer = BytesIO()
            gz = gzip.GzipFile(fileobj=gzip_buffer, mode='wb')
            gz.write(data)
            gz.close()
            data = gzip_buffer.getvalue()

        if not filename_or_buffer:
            return data

        if isinstance(filename_or_buffer, str):
            fp = open(filename_or_buffer, 'wb')
            fp.write(data)
            fp.close()
        else:
            filename_or_buffer.write(data)

    def __getitem__(self, key: str) -> _TAG_Value:
        return self.value[key]

    def __setitem__(self, key: str, tag: _TAG_Value):
        self.value[key] = tag

    def __delitem__(self, key: str):
        del self.value[key]

    def __iter__(self):
        yield from self.value

    def __contains__(self, key: str) -> bool:
        return key in self.value

    def __len__(self) -> int:
        return self.value.__len__()

    def __eq__(self, other):
        return self.value.__eq__(other.value)


def load(filename="", buffer=None) -> NBTFile:
    if filename:
        buffer = open(filename, "rb")
    data_in = buffer

    if hasattr(buffer, "read"):
        data_in = buffer.read()

    if hasattr(buffer, "close"):
        buffer.close()
    else:
        print("[Warning]: Input buffer didn't have close() function. Memory leak may occur!")

    data_in = safe_gunzip(data_in)

    cdef buffer_context context = buffer_context()
    context.offset = 1
    context.buffer = data_in
    context.size = len(data_in)

    if len(data_in) < 1:
        return # Raise error here

    cdef unsigned int * magic_num = <unsigned int *> context.buffer

    if context.buffer[0] != _ID_COMPOUND:
        return # Raise another error

    name = load_name(context)
    tag = load_compound_tag(context)

    file = NBTFile(tag, name)

    return file

cdef TAG_Byte load_byte(buffer_context context):
    cdef TAG_Byte tag = TAG_Byte(read_data(context, 1)[0])
    return tag

cdef TAG_Short load_short(buffer_context context):
    cdef short* pointer = <short*> read_data(context, 2)
    cdef TAG_Short tag = TAG_Short.__new__(TAG_Short)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 2)
    return tag

cdef TAG_Int load_int(buffer_context context):
    cdef int* pointer = <int*> read_data(context, 4)
    cdef TAG_Int tag = TAG_Int.__new__(TAG_Int)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 4)
    return tag

cdef TAG_Long load_long(buffer_context context):
    cdef long long * pointer = <long long *> read_data(context, 8)
    cdef TAG_Long tag = TAG_Long.__new__(TAG_Long)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 8)
    return tag

cdef TAG_Float load_float(buffer_context context):
    cdef float* pointer = <float*> read_data(context, 4)
    cdef TAG_Float tag = TAG_Float.__new__(TAG_Float)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 4)
    return tag

cdef TAG_Double load_double(buffer_context context):
    cdef double * pointer = <double *> read_data(context, 8)
    cdef TAG_Double tag = TAG_Double.__new__(TAG_Double)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 8)
    return tag

cdef _TAG_Compound load_compound_tag(buffer_context context):
    cdef char tagID
    #cdef str name
    cdef _TAG_Compound root_tag = TAG_Compound()
    #cdef _TAG_Value tag
    cdef tuple tup

    while True:
        tagID = read_data(context, 1)[0]
        if tagID == _ID_END:
            break
        else:
            tup = load_named(context, tagID)
            root_tag[tup[0]] = tup[1]
    return root_tag

cdef str load_string(buffer_context context):
    cdef unsigned short * pointer = <unsigned short *> read_data(context, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2)
    b = read_data(context, length)
    return PyUnicode_DecodeUTF8(b, length, "strict")

cdef TAG_Byte_Array load_byte_array(buffer_context context):
    cdef int* pointer = <int *> read_data(context, 4)
    cdef int length = pointer[0]

    to_little_endian(&length, 4)

    byte_length = length
    cdef char* arr = read_data(context, byte_length)
    return TAG_Byte_Array(numpy.frombuffer(arr[:byte_length], dtype=TAG_Byte_Array.data_type, count=length))

cdef TAG_Int_Array load_int_array(buffer_context context):
    cdef int* pointer = <int*> read_data(context, 4)
    cdef int length = pointer[0]
    to_little_endian(&length, 4)

    byte_length = length * 4
    cdef char* arr = read_data(context, byte_length)
    return TAG_Int_Array(numpy.frombuffer(arr[:byte_length], dtype=TAG_Int_Array.data_type, count=length))

cdef TAG_Long_Array load_long_array(buffer_context context):
    cdef int* pointer = <int*> read_data(context, 4)
    cdef int length = pointer[0]
    to_little_endian(&length, 4)

    byte_length = length * 8
    cdef char* arr = read_data(context, byte_length)
    return TAG_Long_Array(numpy.frombuffer(arr[:byte_length], dtype=TAG_Int_Array.data_type, count=length))

cdef _TAG_List load_list(buffer_context context):
    cdef char list_type = read_data(context, 1)[0]
    cdef int* pointer = <int*> read_data(context, 4)
    cdef int length = pointer[0]
    to_little_endian(&length, 4)

    cdef _TAG_List tag = TAG_List(list_data_type=list_type)
    cdef list val = tag.value
    cdef int i
    for i in range(length):
        PyList_Append(val, load_tag(list_type, context))

    return tag

cdef inline void cwrite(object obj, char* buf, size_t length):
    obj.write(buf[:length])

cdef save_tag_id(char tag_id, object buffer):
    cwrite(buffer, &tag_id, 1)

cdef void save_tag_name(str name, object buffer):
    save_string(name.encode("utf-8"), buffer)

cdef void save_string(bytes value, object buffer):
    cdef short length = <short> len(value)
    cdef char* s = value
    to_little_endian(&length, 2)
    cwrite(buffer, <char*> &length, 2)
    cwrite(buffer, s, len(value))

cdef void save_array(object value, object buffer, char size):
    value = value.tostring()
    cdef char* s = value
    cdef int length = <int> len(value) // size
    to_little_endian(&length, 4)
    cwrite(buffer, <char*> &length, 4)
    cwrite(buffer, s, len(value))

cdef void save_byte(char value, object buffer):
    cwrite(buffer, <char*> &value, 1)

cdef void save_short(short value, object buffer):
    to_little_endian(&value, 2)
    cwrite(buffer, <char*> &value, 2)

cdef void save_int(int value, object buffer):
    to_little_endian(&value, 4)
    cwrite(buffer, <char*> &value, 4)

cdef void save_long(long long value, object buffer):
    to_little_endian(&value, 8)
    cwrite(buffer, <char*> &value, 8)

cdef void save_float(float value, object buffer):
    to_little_endian(&value, 4)
    cwrite(buffer, <char*> &value, 4)

cdef void save_double(double value, object buffer):
    to_little_endian(&value, 8)
    cwrite(buffer, <char*> &value, 8)

cdef void save_tag_value(_TAG_Value tag, object buf):
    cdef char tagID = tag.tag_id
    if tagID == _ID_BYTE:
        (<TAG_Byte> tag).save_value(buf)

    if tagID == _ID_SHORT:
        (<TAG_Short> tag).save_value(buf)

    if tagID == _ID_INT:
        (<TAG_Int> tag).save_value(buf)

    if tagID == _ID_LONG:
        (<TAG_Long> tag).save_value(buf)

    if tagID == _ID_FLOAT:
        (<TAG_Float> tag).save_value(buf)

    if tagID == _ID_DOUBLE:
        (<TAG_Double> tag).save_value(buf)

    if tagID == _ID_BYTE_ARRAY:
        (<TAG_Byte_Array> tag).save_value(buf)

    if tagID == _ID_STRING:
        (<TAG_String> tag).save_value(buf)

    if tagID == _ID_LIST:
        (<_TAG_List> tag).save_value(buf)

    if tagID == _ID_COMPOUND:
        (<_TAG_Compound> tag).save_value(buf)

    if tagID == _ID_INT_ARRAY:
        (<TAG_Int_Array> tag).save_value(buf)

    if tagID == _ID_LONG_ARRAY:
        (<TAG_Long_Array> tag).save_value(buf)