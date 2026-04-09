import re

from ._errors import SNBTParseError
from ._value cimport AbstractBaseTag
from ._int cimport ByteTag, ShortTag, IntTag, LongTag
from ._float cimport FloatTag, DoubleTag
from ._array cimport ByteArrayTag, IntArrayTag, LongArrayTag
from ._string cimport StringTag
from ._list cimport CyListTag
from ._compound cimport CyCompoundTag

whitespace = re.compile(r"[ \t\r\n]*")
int_numeric = re.compile(r"[+-]?\d+[bBsSlL]?")
# If the letter code and decimal do not exist it is parsed as a string tag.
float_numeric = re.compile(r"[+-]?((((\d+\.\d*)|(\d*\.\d+))([eE][+-]?\d+)?)|((\d+|(\d+\.\d*)|(\d*\.\d+))([eE][+-]?\d+)?[fFdD]))")
alnumplus = re.compile(r"[A-Za-z0-9._+-]+")
comma = re.compile(r"[ \t\r\n]*,[ \t\r\n]*")
colon = re.compile(r"[ \t\r\n]*:[ \t\r\n]*")
array_lookup = {'B': ByteArrayTag, 'I': IntArrayTag, 'L': LongArrayTag}

cdef int _strip_whitespace(unicode snbt, int index):
    cdef object match

    match = whitespace.match(snbt, index)
    if match is None:
        return index
    else:
        return match.end()

cdef int _strip_comma(unicode snbt, int index, unicode end_chr) except -1:
    cdef object match

    match = comma.match(snbt, index)
    if match is None:
        index = _strip_whitespace(snbt, index)
        if snbt[index] != end_chr:
            raise SNBTParseError(
                f'Expected a comma or {end_chr} at {index} but got ->{snbt[index:index + 10]} instead',
                index=index
            )
    else:
        index = match.end()
    return index

cdef int _strip_colon(unicode snbt, int index) except -1:
    cdef object match

    match = colon.match(snbt, index)
    if match is None:
        raise SNBTParseError(
            f'Expected : at {index} but got ->{snbt[index:index + 10]} instead',
            index=index
        )
    else:
        return match.end()

cdef inline unescape(unicode string):
    return string.replace('\\"', '"').replace("\\\\", "\\")

cdef tuple _capture_string(unicode snbt, int index):
    cdef unicode val, quote
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
        if match is None:
            raise SNBTParseError(
                f'Expected a string at {index} but got ->{snbt[index:index + 10]} instead',
                index=index
            )
        val = match.group()
        index = match.end()

    return val, strict_str, index

cdef tuple _parse_snbt_recursive(unicode snbt, int index=0):
    cdef dict data_
    cdef list array
    cdef unicode array_type_chr
    cdef object array_type, first_data_type
    cdef AbstractBaseTag nested_data, data
    cdef unicode val
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
        data = CyCompoundTag.create(data_)
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
                        f'Expected an integer value or ] at {index} but got ->{snbt[index:index + 10]} instead',
                        index=index
                    )
                else:
                    val = match.group()
                    if array_type_chr in {"B", "L"}:
                        if val[-1].upper() == array_type_chr:
                            val = val[:-1]
                        else:
                            raise SNBTParseError(
                                f'Expected the datatype marker "{array_type_chr}" at {index} but got ->{snbt[index:index + 10]} instead',
                                index=index
                            )
                    array.append(int(val))
                    index = match.end()

                index = _strip_comma(snbt, index, ']')
            data = array_type(array)
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
                        f'Expected type {first_data_type.__name__} but got {nested_data.__class__.__name__} at {index}',
                        index=index
                    )
                else:
                    index = index_
                array.append(nested_data)
                index = _strip_comma(snbt, index, ']')

            if first_data_type is None:
                data = CyListTag.create()
            else:
                data = CyListTag.create(array, first_data_type().tag_id)

        # skip the ]
        index += 1

    else:
        val, strict_str, index = _capture_string(snbt, index)
        if strict_str:
            data = StringTag(val)
        else:
            if int_numeric.fullmatch(val) is not None:
                # we have an int type
                if val[-1] in {'b', 'B'}:
                    data = ByteTag(int(val[:-1]))
                elif val[-1] in {'s', 'S'}:
                    data = ShortTag(int(val[:-1]))
                elif val[-1] in {'l', 'L'}:
                    data = LongTag(int(val[:-1]))
                else:
                    data = IntTag(int(val))
            elif float_numeric.fullmatch(val) is not None:
                # we have a float type
                if val[-1] in {'f', 'F'}:
                    data = FloatTag(val[:-1])
                elif val[-1] in {'d', 'D'}:
                    data = DoubleTag(val[:-1])
                else:
                    data = DoubleTag(val)
            elif val.lower() == "false":
                data = ByteTag(0)
            elif val.lower() == "true":
                data = ByteTag(1)
            else:
                # we just have a string type
                data = StringTag(val)

    return data, index

cpdef AbstractBaseTag from_snbt(unicode snbt):
    try:
        return _parse_snbt_recursive(snbt)[0]
    except SNBTParseError as e:
        raise e
    except IndexError:
        raise SNBTParseError('SNBT string is incomplete. Reached the end of the string.')
    except Exception as e:
        raise SNBTParseError(e)
