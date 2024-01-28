from copy import copy
from typing import Any


cdef class AbstractBase:
    """Abstract Base class for all Tags and the NamedTag"""


cdef class AbstractBaseTag(AbstractBase):
    """Abstract Base Class for all Tag classes"""
    tag_id: int = -1

    cdef TagNode to_node(self):
        raise NotImplementedError

    @property
    def py_data(self) -> Any:
        """
        A python representation of the class. Note that the return type is undefined and may change in the future.
        You would be better off using the py_{type} or np_array properties if you require a fixed type.
        This is here for convenience to get a python representation under the same property name.
        """
        raise NotImplementedError

    def __eq__(self, other):
        """
        Check if the instance is equal to another instance.
        This will only return True if the tag type is the same and the data contained is the same.

        >>> from amulet_nbt import ByteTag, ShortTag
        >>> tag1 = ByteTag(1)
        >>> tag2 = ByteTag(2)
        >>> tag3 = ShortTag(1)
        >>> tag1 == tag1  # True
        >>> tag1 == tag2  # False
        >>> tag1 == tag3  # False
        """
        raise NotImplementedError

    def __repr__(self):
        """
        A string representation of the object to show how it can be constructed.
        >>> from amulet_nbt import ByteTag
        >>> tag = ByteTag(1)
        >>> repr(tag)  # "ByteTag(1)"
        """
        raise NotImplementedError

    def __str__(self):
        """A string representation of the object."""
        raise NotImplementedError

    def __reduce__(self):
        raise NotImplementedError

    def copy(self):
        """Return a shallow copy of the class"""
        return copy(self)

    def __copy__(self):
        """
        A shallow copy of the class
        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.copy(tag)
        """
        raise NotImplementedError

    def __deepcopy__(self, memo=None):
        """
        A deep copy of the class
        >>> import copy
        >>> from amulet_nbt import ListTag
        >>> tag = ListTag()
        >>> tag2 = copy.deepcopy(tag)
        """
        raise NotImplementedError


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    """Abstract Base Class for all immutable Tag classes"""
    def __hash__(self):
        raise NotImplementedError


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    """Abstract Base Class for all mutable Tag classes"""
    __hash__ = None
