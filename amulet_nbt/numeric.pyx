from .value cimport BaseImmutableTag


cdef class BaseNumericTag(BaseImmutableTag):
    def __repr__(self):
        raise NotImplementedError

    def __add__(self, other):
        raise NotImplementedError

    def __radd__(self, other):
        raise NotImplementedError

    def __iadd__(self, other):
        raise NotImplementedError

    def __sub__(self, other):
        raise NotImplementedError

    def __rsub__(self, other):
        raise NotImplementedError

    def __isub__(self, other):
        raise NotImplementedError

    def __mul__(self, other):
        raise NotImplementedError

    def __rmul__(self, other):
        raise NotImplementedError

    def __imul__(self, other):
        raise NotImplementedError

    def __truediv__(self, other):
        raise NotImplementedError

    def __rtruediv__(self, other):
        raise NotImplementedError

    def __itruediv__(self, other):
        raise NotImplementedError

    def __floordiv__(self, other):
        raise NotImplementedError

    def __rfloordiv__(self, other):
        raise NotImplementedError

    def __ifloordiv__(self, other):
        raise NotImplementedError

    def __mod__(self, other):
        raise NotImplementedError

    def __rmod__(self, other):
        raise NotImplementedError

    def __imod__(self, other):
        raise NotImplementedError

    def __divmod__(self, other):
        raise NotImplementedError

    def __rdivmod__(self, other):
        raise NotImplementedError

    def __pow__(self, power, modulo):
        raise NotImplementedError

    def __rpow__(self, other, modulo):
        raise NotImplementedError

    def __ipow__(self, other):
        raise NotImplementedError

    def __neg__(self):
        raise NotImplementedError

    def __pos__(self):
        raise NotImplementedError

    def __abs__(self):
        raise NotImplementedError

    def __int__(self):
        raise NotImplementedError

    def __float__(self):
        raise NotImplementedError

    def __round__(self, n=None):
        raise NotImplementedError

    def __trunc__(self):
        raise NotImplementedError

    def __floor__(self):
        raise NotImplementedError

    def __ceil__(self):
        raise NotImplementedError

    def __bool__(self):
        raise NotImplementedError
