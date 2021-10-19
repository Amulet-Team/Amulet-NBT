import gzip
import zlib
from io import BytesIO
from typing import Optional, Union, Tuple, List, Iterator, BinaryIO, Sequence
import numpy
import os
from cpython cimport PyUnicode_DecodeUTF8, PyUnicode_DecodeCharmap, PyList_Append


CHAR_MAP = "".join(map(chr, range(256)))


cdef class buffer_context:
    cdef size_t offset
    cdef char *buffer
    cdef size_t size

cdef char *read_data(buffer_context context, size_t tag_size) except NULL:
    if tag_size > context.size - context.offset:
        raise NBTFormatError(
            f"NBT Stream too short. Asked for {tag_size:d}, only had {(context.size - context.offset):d}")

    cdef char*value = context.buffer + context.offset
    context.offset += tag_size
    return value

cdef void to_little_endian(void *data_buffer, int num_bytes, bint little_endian = False):
    if little_endian:
        return

    cdef unsigned char *buf = <unsigned char *> data_buffer
    cdef int i

    for i in range((num_bytes + 1) // 2):
        buf[i], buf[num_bytes - i - 1] = buf[num_bytes - i - 1], buf[i]

cdef str load_name(buffer_context context, bint little_endian):
    cdef unsigned short *pointer = <unsigned short *> read_data(context, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2, little_endian)
    b = read_data(context, length)

    return PyUnicode_DecodeUTF8(b, length, "strict")

cdef tuple load_named(buffer_context context, char tagID, bint little_endian):
    cdef str name = load_name(context, little_endian)
    cdef BaseTag tag = load_tag(tagID, context, little_endian)
    return name, tag

cdef BaseTag load_tag(char tagID, buffer_context context, bint little_endian):
    if tagID == ID_BYTE:
        return load_byte(context, little_endian)

    if tagID == ID_SHORT:
        return load_short(context, little_endian)

    if tagID == ID_INT:
        return load_int(context, little_endian)

    if tagID == ID_LONG:
        return load_long(context, little_endian)

    if tagID == ID_FLOAT:
        return load_float(context, little_endian)

    if tagID == ID_DOUBLE:
        return load_double(context, little_endian)

    if tagID == ID_BYTE_ARRAY:
        return load_byte_array(context, little_endian)

    if tagID == ID_STRING:
        return TAG_String(load_string(context, little_endian))

    if tagID == ID_LIST:
        return load_list(context, little_endian)

    if tagID == ID_COMPOUND:
        return load_compound_tag(context, little_endian)

    if tagID == ID_INT_ARRAY:
        return load_int_array(context, little_endian)

    if tagID == ID_LONG_ARRAY:
        return load_long_array(context, little_endian)

cdef TAG_Byte load_byte(buffer_context context, bint little_endian):
    cdef TAG_Byte tag = TAG_Byte(read_data(context, 1)[0])
    return tag

cdef TAG_Short load_short(buffer_context context, bint little_endian):
    cdef short*pointer = <short*> read_data(context, 2)
    cdef TAG_Short tag = TAG_Short.__new__(TAG_Short)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 2, little_endian)
    return tag

cdef TAG_Int load_int(buffer_context context, bint little_endian):
    cdef int*pointer = <int*> read_data(context, 4)
    cdef TAG_Int tag = TAG_Int.__new__(TAG_Int)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 4, little_endian)
    return tag

cdef TAG_Long load_long(buffer_context context, bint little_endian):
    cdef long long *pointer = <long long *> read_data(context, 8)
    cdef TAG_Long tag = TAG_Long.__new__(TAG_Long)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 8, little_endian)
    return tag

cdef TAG_Float load_float(buffer_context context, bint little_endian):
    cdef float*pointer = <float*> read_data(context, 4)
    cdef TAG_Float tag = TAG_Float.__new__(TAG_Float)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 4, little_endian)
    return tag

cdef TAG_Double load_double(buffer_context context, bint little_endian):
    cdef double *pointer = <double *> read_data(context, 8)
    cdef TAG_Double tag = TAG_Double.__new__(TAG_Double)
    tag.value = pointer[0]
    to_little_endian(&tag.value, 8, little_endian)
    return tag

cdef _TAG_Compound load_compound_tag(buffer_context context, bint little_endian):
    cdef char tagID
    #cdef str name
    cdef _TAG_Compound root_tag = TAG_Compound()
    #cdef BaseTag tag
    cdef tuple tup

    while True:
        tagID = read_data(context, 1)[0]
        if tagID == ID_END:
            break
        else:
            tup = load_named(context, tagID, little_endian)
            root_tag[tup[0]] = tup[1]
    return root_tag

cdef str load_string(buffer_context context, bint little_endian):
    cdef unsigned short *pointer = <unsigned short *> read_data(context, 2)
    cdef unsigned short length = pointer[0]
    to_little_endian(&length, 2, little_endian)
    b = read_data(context, length)
    try:
        return PyUnicode_DecodeUTF8(b, length, "strict")
    except:
        return PyUnicode_DecodeCharmap(b, length, CHAR_MAP, "strict")


cdef TAG_Byte_Array load_byte_array(buffer_context context, bint little_endian):
    cdef int*pointer = <int *> read_data(context, 4)
    cdef int length = pointer[0]

    to_little_endian(&length, 4, little_endian)

    byte_length = length
    cdef char*arr = read_data(context, byte_length)
    data_type = TAG_Byte_Array.little_endian_data_type if little_endian else TAG_Byte_Array.big_endian_data_type
    return TAG_Byte_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))

cdef TAG_Int_Array load_int_array(buffer_context context, bint little_endian):
    cdef int*pointer = <int*> read_data(context, 4)
    cdef int length = pointer[0]
    to_little_endian(&length, 4, little_endian)

    byte_length = length * 4
    cdef char*arr = read_data(context, byte_length)
    cdef object data_type = TAG_Int_Array.little_endian_data_type if little_endian else TAG_Int_Array.big_endian_data_type
    return TAG_Int_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))

cdef TAG_Long_Array load_long_array(buffer_context context, bint little_endian):
    cdef int*pointer = <int*> read_data(context, 4)
    cdef int length = pointer[0]
    to_little_endian(&length, 4, little_endian)

    byte_length = length * 8
    cdef char*arr = read_data(context, byte_length)
    cdef object data_type = TAG_Long_Array.little_endian_data_type if little_endian else TAG_Long_Array.big_endian_data_type
    return TAG_Long_Array(numpy.frombuffer(arr[:byte_length], dtype=data_type, count=length))

cdef _TAG_List load_list(buffer_context context, bint little_endian):
    cdef char list_type = read_data(context, 1)[0]
    cdef int*pointer = <int*> read_data(context, 4)
    cdef int length = pointer[0]
    to_little_endian(&length, 4, little_endian)

    cdef _TAG_List tag = TAG_List(list_data_type=list_type)
    cdef list val = tag.value
    cdef int i
    for i in range(length):
        PyList_Append(val, load_tag(list_type, context, little_endian))

    return tag

cdef inline void cwrite(object obj, char*buf, size_t length):
    obj.write(buf[:length])

cdef inline void write_tag_id(char tag_id, object buffer):
    cwrite(buffer, &tag_id, 1)

cdef inline void write_string(str s, object buffer, bint little_endian):
    cdef bytes b = s.encode("utf-8")
    cdef char *c = b
    cdef short length = <short> len(b)
    write_short(length, buffer, little_endian)
    cwrite(buffer, c, length)

cdef inline void write_array(object value, object buffer, char size, bint little_endian):
    value = value.tobytes()
    cdef char*s = value
    cdef int length = <int> len(value) // size
    to_little_endian(&length, 4, little_endian)
    cwrite(buffer, <char*> &length, 4)
    cwrite(buffer, s, len(value))

cdef inline void write_byte(char value, object buffer):
    cwrite(buffer, &value, 1)

cdef inline void write_short(short value, object buffer, bint little_endian):
    to_little_endian(&value, 2, little_endian)
    cwrite(buffer, <char*> &value, 2)

cdef inline void write_int(int value, object buffer, bint little_endian):
    to_little_endian(&value, 4, little_endian)
    cwrite(buffer, <char*> &value, 4)

cdef inline void write_long(long long value, object buffer, bint little_endian):
    to_little_endian(&value, 8, little_endian)
    cwrite(buffer, <char*> &value, 8)

cdef inline void write_float(float value, object buffer, bint little_endian):
    to_little_endian(&value, 4, little_endian)
    cwrite(buffer, <char*> &value, 4)

cdef inline void write_double(double value, object buffer, bint little_endian):
    to_little_endian(&value, 8, little_endian)
    cwrite(buffer, <char*> &value, 8)
