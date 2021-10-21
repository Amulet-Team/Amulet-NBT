from .value cimport BaseImmutableTag


cdef class BaseNumericTag(BaseImmutableTag):
    def __repr__(self):
        return f"{self.__class__.__name__}({self.value})"

    def __add__(self, other):
        return self.value + other

    def __radd__(self, other):
        return other + self.value

    def __iadd__(self, other):
        return self.__class__(self + other)

    def __sub__(self, other):
        return self.value - other

    def __rsub__(self, other):
        return other - self.value

    def __isub__(self, other):
        return self.__class__(self - other)

    def __mul__(self, other):
        return self.value * other

    def __rmul__(self, other):
        return other * self.value

    def __imul__(self, other):
        return self.__class__(self * other)

    def __truediv__(self, other):
        return self.value / other

    def __rtruediv__(self, other):
        return other / self.value

    def __itruediv__(self, other):
        return self.__class__(self / other)

    def __floordiv__(self, other):
        return self.value // other

    def __rfloordiv__(self, other):
        return other // self.value

    def __ifloordiv__(self, other):
        return self.__class__(self // other)

    def __mod__(self, other):
        return self.value % other

    def __rmod__(self, other):
        return other % self.value

    def __imod__(self, other):
        return self.__class__(self % other)

    def __divmod__(self, other):
        return divmod(self.value, other)

    def __rdivmod__(self, other):
        return divmod(other, self.value)

    def __pow__(self, power, modulo):
        return pow(self.value, power, modulo)

    def __rpow__(self, other, modulo):
        return pow(other, self.value, modulo)

    def __ipow__(self, other):
        return self.__class__(pow(self, other))

    def __neg__(self):
        return self.value.__neg__()

    def __pos__(self):
        return self.value.__pos__()

    def __abs__(self):
        return self.value.__abs__()

    def __int__(self):
        return self.value.__int__()

    def __float__(self):
        return self.value.__float__()

    def __round__(self, n=None):
        return self.value.__round__(n)

    def __trunc__(self):
        return self.value.__trunc__()

    def __floor__(self):
        return self.value.__floor__()

    def __ceil__(self):
        return self.value.__ceil__()

    def __bool__(self):
        return self.value.__bool__()
