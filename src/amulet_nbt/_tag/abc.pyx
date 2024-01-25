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

    def __repr__(self):
        raise NotImplementedError

    def __str__(self):
        raise NotImplementedError

    def __eq__(self, other):
        raise NotImplementedError

    def __reduce__(self):
        raise NotImplementedError

    def copy(self):
        """Return a shallow copy of the class"""
        return copy(self)

    def __deepcopy__(self, memo=None):
        raise NotImplementedError

    def __copy__(self):
        raise NotImplementedError


cdef class AbstractBaseImmutableTag(AbstractBaseTag):
    """Abstract Base Class for all immutable Tag classes"""
    def __hash__(self):
        raise NotImplementedError


cdef class AbstractBaseMutableTag(AbstractBaseTag):
    """Abstract Base Class for all mutable Tag classes"""
    __hash__ = None
