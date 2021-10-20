import re
import numpy
cimport numpy

from .errors import SNBTParseError
from .value cimport BaseTag
from .int cimport TAG_Byte, TAG_Short, TAG_Int, TAG_Long
from .float cimport TAG_Float, TAG_Double
from .array cimport TAG_Byte_Array, TAG_Int_Array, TAG_Long_Array
from .string cimport TAG_String
from .list cimport TAG_List
from .compound cimport TAG_Compound

whitespace = re.compile('[ \t\r\n]*')
int_numeric = re.compile('-?[0-9]+[bBsSlL]?')
float_numeric = re.compile('-?[0-9]+\.?[0-9]*[fFdD]?')
alnumplus = re.compile('[-.a-zA-Z0-9_]*')
comma = re.compile('[ \t\r\n]*,[ \t\r\n]*')
colon = re.compile('[ \t\r\n]*:[ \t\r\n]*')
array_lookup = {'B': TAG_Byte_Array, 'I': TAG_Int_Array, 'L': TAG_Long_Array}

cdef int _strip_whitespace(str snbt, int index):
    cdef object match

    match = whitespace.match(snbt, index)
    if match is None:
        return index
    else:
        return match.end()

cdef int _strip_comma(str snbt, int index, str end_chr) except -1:
    cdef object match

    match = comma.match(snbt, index)
    if match is None:
        index = _strip_whitespace(snbt, index)
        if snbt[index] != end_chr:
            raise SNBTParseError(f'Expected a comma or {end_chr} at {index} but got ->{snbt[index:index + 10]} instead')
    else:
        index = match.end()
    return index

cdef int _strip_colon(str snbt, int index) except -1:
    cdef object match

    match = colon.match(snbt, index)
    if match is None:
        raise SNBTParseError(f'Expected : at {index} but got ->{snbt[index:index + 10]} instead')
    else:
        return match.end()

cdef inline unescape(str string):
    return string.replace('\\"', '"').replace("\\\\", "\\")

cdef tuple _capture_string(str snbt, int index):
    cdef str val, quote
    cdef bint strict_str
    cdef int end_index
    cdef object match

    if snbt[index] in ('"', "'"):
        quote = snbt[index]
        strict_str = True
        index += 1
        end_index = index
        while not (snbt[end_index] == quote and not (len(snbt[:end_index]) - len(snbt[:end_index].rstrip('\\')))):
            end_index += 1
        val = unescape(snbt[index:end_index])
        index = end_index + 1
    else:
        strict_str = False
        match = alnumplus.match(snbt, index)
        val = match.group()
        index = match.end()

    return val, strict_str, index

cdef tuple _parse_snbt_recursive(str snbt, int index=0):
    cdef dict data_
    cdef list array
    cdef str array_type_chr
    cdef object array_type, first_data_type, int_match, float_match
    cdef BaseTag nested_data, data
    cdef str val
    cdef bint strict_str

    index = _strip_whitespace(snbt, index)
    if snbt[index] == '{':
        data_ = {}
        index += 1
        index = _strip_whitespace(snbt, index)
        while snbt[index] != '}':
            # read the key
            key, _, index = _capture_string(snbt, index)

            # get around the colon
            index = _strip_colon(snbt, index)

            # load the data and save it to the dictionary
            nested_data, index = _parse_snbt_recursive(snbt, index)
            data_[key] = nested_data

            index = _strip_comma(snbt, index, '}')
        data = TAG_Compound(data_)
        # skip the }
        index += 1

    elif snbt[index] == '[':
        index += 1
        index = _strip_whitespace(snbt, index)
        if snbt[index:index + 2] in {'B;', 'I;', 'L;'}:
            # array
            array = []
            array_type_chr = snbt[index]
            array_type = array_lookup[array_type_chr]
            index += 2
            index = _strip_whitespace(snbt, index)

            while snbt[index] != ']':
                match = int_numeric.match(snbt, index)
                if match is None:
                    raise SNBTParseError(
                        f'Expected an integer value or ] at {index} but got ->{snbt[index:index + 10]} instead')
                else:
                    val = match.group()
                    if val[-1].isalpha():
                        if val[-1] == array_type_chr:
                            val = val[:-1]
                        else:
                            raise SNBTParseError(
                                f'Expected the datatype marker "{array_type_chr}" at {index} but got ->{snbt[index:index + 10]} instead')
                    array.append(int(val))
                    index = match.end()

                index = _strip_comma(snbt, index, ']')
            data = array_type(numpy.asarray(array, dtype=array_type.big_endian_data_type))
        else:
            # list
            array = []
            first_data_type = None
            while snbt[index] != ']':
                nested_data, index_ = _parse_snbt_recursive(snbt, index)
                if first_data_type is None:
                    first_data_type = nested_data.__class__
                if not isinstance(nested_data, first_data_type):
                    raise SNBTParseError(
                        f'Expected type {first_data_type.__name__} but got {nested_data.__class__.__name__} at {index}')
                else:
                    index = index_
                array.append(nested_data)
                index = _strip_comma(snbt, index, ']')

            if first_data_type is None:
                data = TAG_List()
            else:
                data = TAG_List(array, first_data_type().tag_id)

        # skip the ]
        index += 1

    else:
        val, strict_str, index = _capture_string(snbt, index)
        if strict_str:
            data = TAG_String(val)
        else:
            int_match = int_numeric.match(val)
            if int_match is not None and int_match.end() == len(val):
                # we have an int type
                if val[-1] in {'b', 'B'}:
                    data = TAG_Byte(int(val[:-1]))
                elif val[-1] in {'s', 'S'}:
                    data = TAG_Short(int(val[:-1]))
                elif val[-1] in {'l', 'L'}:
                    data = TAG_Long(int(val[:-1]))
                else:
                    data = TAG_Int(int(val))
            else:
                float_match = float_numeric.match(val)
                if float_match is not None and float_match.end() == len(val):
                    # we have a float type
                    if val[-1] in {'f', 'F'}:
                        data = TAG_Float(float(val[:-1]))
                    elif val[-1] in {'d', 'D'}:
                        data = TAG_Double(float(val[:-1]))
                    else:
                        data = TAG_Double(float(val))
                else:
                    # we just have a string type
                    data = TAG_String(val)

    return data, index

def from_snbt(snbt: str) -> AnyNBT:
    try:
        return _parse_snbt_recursive(snbt)[0]
    except SNBTParseError as e:
        raise SNBTParseError(e)
    except IndexError:
        raise SNBTParseError('SNBT string is incomplete. Reached the end of the string.')
