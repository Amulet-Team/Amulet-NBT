{{py:from template import include}}
{{include("BaseImmutableTag.pyx", cls_name=cls_name)}}

    def __repr__({{cls_name}} self):
        return f"{self.__class__.__name__}({self.value_})"

    def __add__({{cls_name}} self, other):
        return self.value_ + other

    def __radd__({{cls_name}} self, other):
        return other + self.value_

    def __iadd__({{cls_name}} self, other):
        res = self + other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __sub__({{cls_name}} self, other):
        return self.value_ - other

    def __rsub__({{cls_name}} self, other):
        return other - self.value_

    def __isub__({{cls_name}} self, other):
        res = self - other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mul__({{cls_name}} self, other):
        return self.value_ * other

    def __rmul__({{cls_name}} self, other):
        return other * self.value_

    def __imul__({{cls_name}} self, other):
        res = self * other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __truediv__({{cls_name}} self, other):
        return self.value_ / other

    def __rtruediv__({{cls_name}} self, other):
        return other / self.value_

    def __itruediv__({{cls_name}} self, other):
        res = self / other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __floordiv__({{cls_name}} self, other):
        return self.value_ // other

    def __rfloordiv__({{cls_name}} self, other):
        return other // self.value_

    def __ifloordiv__({{cls_name}} self, other):
        res = self // other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __mod__({{cls_name}} self, other):
        return self.value_ % other

    def __rmod__({{cls_name}} self, other):
        return other % self.value_

    def __imod__({{cls_name}} self, other):
        res = self % other
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __divmod__({{cls_name}} self, other):
        return divmod(self.value_, other)

    def __rdivmod__({{cls_name}} self, other):
        return divmod(other, self.value_)

    def __pow__({{cls_name}} self, power, modulo):
        return pow(self.value_, power, modulo)

    def __rpow__({{cls_name}} self, other, modulo):
        return pow(other, self.value_, modulo)

    def __ipow__({{cls_name}} self, other):
        res = pow(self, other)
        if isinstance(res, (int, float)):
            return self.__class__(res)
        return res

    def __neg__({{cls_name}} self):
        return self.value_.__neg__()

    def __pos__({{cls_name}} self):
        return self.value_.__pos__()

    def __abs__({{cls_name}} self):
        return self.value_.__abs__()

    def __int__({{cls_name}} self):
        return self.value_.__int__()

    def __float__({{cls_name}} self):
        return self.value_.__float__()

    def __round__({{cls_name}} self, n=None):
        return round(self.value_, n)

    def __trunc__({{cls_name}} self):
        return self.value_.__trunc__()

    def __floor__({{cls_name}} self):
        return floor(self.value_)

    def __ceil__({{cls_name}} self):
        return ceil(self.value_)

    def __bool__({{cls_name}} self):
        return self.value_.__bool__()