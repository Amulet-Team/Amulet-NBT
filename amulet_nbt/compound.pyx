from io import BytesIO
import re
from typing import Iterator, List
from copy import copy, deepcopy

from .value cimport BaseTag, BaseMutableTag
from .const cimport ID_END, ID_COMPOUND, CommaSpace, CommaNewline
from .util cimport write_byte, BufferContext, read_byte, read_string
from .load_nbt cimport load_payload

NON_QUOTED_KEY = re.compile('[A-Za-z0-9._+-]+')


cdef class CompoundTag(BaseMutableTag):
    """
    This class behaves like a python dictionary.
    All keys must be strings and all values must be NBT data types.
    """
    tag_id = ID_COMPOUND

    def __init__(CompoundTag self, object value = (), **kwvals):
        cdef dict dict_value = dict(value)
        dict_value.update(kwvals)
        CompoundTag._check_dict(dict_value)
        self.value_ = dict_value

    def get(self, key, default=None):
        return self.value_.get(key, default)
    get.__doc__ = dict.get.__doc__
    
    def pop(self, *args, **kwargs):
        return self.value_.pop(*args, **kwargs)
    pop.__doc__ = dict.pop.__doc__
    
    def popitem(self):
        return self.value_.popitem()
    popitem.__doc__ = dict.popitem.__doc__
    
    def clear(self, *args, **kwargs):
        return self.value_.clear(*args, **kwargs)
    clear.__doc__ = dict.clear.__doc__
    
    def keys(self, *args, **kwargs):
        return self.value_.keys(*args, **kwargs)
    keys.__doc__ = dict.keys.__doc__
    
    def values(self, *args, **kwargs):
        return self.value_.values(*args, **kwargs)
    values.__doc__ = dict.values.__doc__
    
    def items(self, *args, **kwargs):
        return self.value_.items(*args, **kwargs)
    items.__doc__ = dict.items.__doc__
    
    def __str__(CompoundTag self):
        return str(self.value_)

    def __dir__(CompoundTag self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(CompoundTag self, other):
        return self.value_ == other

    def __ge__(CompoundTag self, other):
        return self.value_ >= other

    def __gt__(CompoundTag self, other):
        return self.value_ > other

    def __le__(CompoundTag self, other):
        return self.value_ <= other

    def __lt__(CompoundTag self, other):
        return self.value_ < other

    def __reduce__(CompoundTag self):
        return self.__class__, (self.value_,)

    def __deepcopy__(CompoundTag self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(CompoundTag self):
        return self.__class__(self.value_)

    @property
    def value(CompoundTag self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return copy(self.value_)

    __hash__ = None

    @staticmethod
    def fromkeys(object keys, BaseTag value=None):
        cdef dict dict_value = dict.fromkeys(keys, value)
        CompoundTag._check_dict(dict_value)
        cdef CompoundTag compound = CompoundTag.__new__(CompoundTag)
        compound.value_ = dict_value
        return compound
    fromkeys.__func__.__doc__ = dict.fromkeys.__doc__

    @staticmethod
    cdef _check_dict(dict value):
        cdef str key
        cdef BaseTag val
        for key, val in value.items():
            if key is None or val is None:
                raise TypeError()

    cdef str _to_snbt(CompoundTag self):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self.value_, key=lambda k: (k.lower(), k.swapcase())):
            elem = self.value_[name]
            if NON_QUOTED_KEY.fullmatch(name) is None:
                tags.append(f'"{name}": {elem.to_snbt()}')
            else:
                tags.append(f'{name}: {elem.to_snbt()}')
        return f"{{{CommaSpace.join(tags)}}}"

    cdef str _pretty_to_snbt(CompoundTag self, str indent_chr, int indent_count=0, bint leading_indent=True):
        cdef str name
        cdef BaseTag elem
        cdef list tags = []
        for name in sorted(self.value_, key=lambda k: (k.lower(), k.swapcase())):
            elem = self.value_[name]
            tags.append(f'{indent_chr * (indent_count + 1)}"{name}": {elem._pretty_to_snbt(indent_chr, indent_count + 1, False)}')
        if tags:
            return f"{indent_chr * indent_count * leading_indent}{{\n{CommaNewline.join(tags)}\n{indent_chr * indent_count}}}"
        else:
            return f"{indent_chr * indent_count * leading_indent}{{}}"

    cdef void write_payload(CompoundTag self, object buffer: BytesIO, bint little_endian) except *:
        cdef str key
        cdef BaseTag tag

        for key, tag in self.value_.items():
            tag.write_tag(buffer, key, little_endian)
        write_byte(ID_END, buffer)

    @staticmethod
    cdef CompoundTag read_payload(BufferContext buffer, bint little_endian):
        cdef char tag_type
        cdef CompoundTag tag = CompoundTag()
        cdef str name
        cdef BaseTag child_tag

        while True:
            tag_type = read_byte(buffer)
            if tag_type == ID_END:
                break
            else:
                name = read_string(buffer, little_endian)
                child_tag = load_payload(buffer, tag_type, little_endian)
                tag[name] = child_tag
        return tag

    cpdef bint strict_equals(CompoundTag self, other):
        """Does the data and data type match the other object."""
        cdef str self_key, other_key
        if (
                isinstance(other, CompoundTag)
                and self.keys() == other.keys()
        ):
            for self_key, other_key in zip(self, other):
                if not self[self_key].strict_equals(other[other_key]):
                    return False
            return True
        return False

    def __repr__(CompoundTag self):
        return f"{self.__class__.__name__}({repr(self.value_)})"

    def __getitem__(CompoundTag self, str key not None) -> BaseTag:
        return self.value_[key]

    def __setitem__(CompoundTag self, str key not None, BaseTag value not None):
        self.value_[key] = value

    def setdefault(CompoundTag self, str key not None, BaseTag value not None):
        return self.value_.setdefault(key, value)
    setdefault.__doc__ = dict.setdefault.__doc__

    def update(CompoundTag self, object other=(), **others):
        cdef dict dict_other = dict(other)
        dict_other.update(others)
        CompoundTag._check_dict(dict_other)
        self.value_.update(dict_other)
    update.__doc__ = dict.update.__doc__

    def __delitem__(CompoundTag self, str key not None):
        del self.value_[key]

    def __iter__(CompoundTag self) -> Iterator[str]:
        yield from self.value_

    def __contains__(CompoundTag self, object key) -> bool:
        return key in self.value_

    def __len__(CompoundTag self) -> int:
        return self.value_.__len__()

    def __reversed__(CompoundTag self):
        return reversed(self.value_)


cdef class NamedCompoundTag(CompoundTag):
    def __init__(self, object value=(), str name=""):
        super().__init__(value)
        self.name = name

    def to_nbt(
        self,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().to_nbt(
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def save_to(
        self,
        object filepath_or_buffer=None,
        *,
        bint compressed=True,
        bint little_endian=False,
        str name="",
    ):
        return super().save_to(
            filepath_or_buffer,
            compressed=compressed,
            little_endian=little_endian,
            name=name or self.name
        )

    def __eq__(self, other):
        if isinstance(other, CompoundTag) and super().__eq__(other):
            if isinstance(other, NamedCompoundTag):
                return self.name == other.name
            return True
        return False

    def __repr__(self):
        return f'{self.__class__.__name__}({super().__repr__()}, "{self.name}")'

    def __dir__(self) -> List[str]:
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __copy__(self):
        return NamedCompoundTag(self.value_, self.name)

    def __deepcopy__(self, memodict=None):
        return NamedCompoundTag(
            deepcopy(self.value),
            self.name
        )

    def __reduce__(self):
        return NamedCompoundTag, (self.value, self.name)
