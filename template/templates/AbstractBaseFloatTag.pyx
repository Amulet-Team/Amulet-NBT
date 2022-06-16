{{py:from template import include}}
{{include("AbstractBaseNumericTag.pyx", **locals())}}

    @property
    def py_float({{cls_name}} self) -> float:
        """
        A python float representation of the class.
        The returned data is immutable so changes will not mirror the instance.
        """
        return self.value_

    if __major__ <= 2:
        def __add__(self, other):
            warnings.warn(f"__add__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(self) + primitive_conversion(other))

        def __sub__(self, other):
            warnings.warn(f"__sub__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(self) - primitive_conversion(other))

        def __mul__(self, other):
            warnings.warn(f"__mul__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(self) * primitive_conversion(other))

        def __truediv__(self, other):
            warnings.warn(f"__truediv__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(self) / primitive_conversion(other))

        def __floordiv__(self, other):
            warnings.warn(f"__floordiv__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) // primitive_conversion(other)

        def __mod__(self, other):
            warnings.warn(f"__mod__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) % primitive_conversion(other)

        def __divmod__(self, other):
            warnings.warn(f"__divmod__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return divmod(primitive_conversion(self), primitive_conversion(other))

        def __pow__(self, power, modulo):
            warnings.warn(f"__pow__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return pow(primitive_conversion(self), power, modulo)

        def __lshift__(self, other):
            warnings.warn(f"__lshift__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) << primitive_conversion(other)

        def __rshift__(self, other):
            warnings.warn(f"__rshift__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) >> primitive_conversion(other)

        def __and__(self, other):
            warnings.warn(f"__and__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) & primitive_conversion(other)

        def __xor__(self, other):
            warnings.warn(f"__xor__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) ^ primitive_conversion(other)

        def __or__(self, other):
            warnings.warn(f"__or__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(self) | primitive_conversion(other)

        def __radd__(self, other):
            warnings.warn(f"__radd__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(other) + primitive_conversion(self))

        def __rsub__(self, other):
            warnings.warn(f"__rsub__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(other) - primitive_conversion(self))

        def __rmul__(self, other):
            warnings.warn(f"__rmul__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) * primitive_conversion(self)

        def __rtruediv__(self, other):
            warnings.warn(f"__rtruediv__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return float(primitive_conversion(other) / primitive_conversion(self))

        def __rfloordiv__(self, other):
            warnings.warn(f"__rfloordiv__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) // primitive_conversion(self)

        def __rmod__(self, other):
            warnings.warn(f"__rmod__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) % primitive_conversion(self)

        def __rdivmod__(self, other):
            warnings.warn(f"__rdivmod__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return divmod(primitive_conversion(other), primitive_conversion(self))

        def __rpow__(self, other, modulo):
            warnings.warn(f"__rpow__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return pow(primitive_conversion(other), primitive_conversion(self), modulo)

        def __rlshift__(self, other):
            warnings.warn(f"__rlshift__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) << primitive_conversion(self)

        def __rrshift__(self, other):
            warnings.warn(f"__rrshift__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) >> primitive_conversion(self)

        def __rand__(self, other):
            warnings.warn(f"__rand__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) & primitive_conversion(self)

        def __rxor__(self, other):
            warnings.warn(f"__rxor__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) ^ primitive_conversion(self)

        def __ror__(self, other):
            warnings.warn(f"__ror__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return primitive_conversion(other) | primitive_conversion(self)

        def __neg__(self):
            warnings.warn(f"__neg__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return -self.value_

        def __pos__(self):
            warnings.warn(f"__pos__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return +self.value_

        def __abs__(self):
            warnings.warn(f"__abs__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return abs(self.value_)

        def __round__(self, n=None):
            warnings.warn(f"__round__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return round(self.value_, n)

        def __trunc__(self):
            warnings.warn(f"__trunc__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return trunc(self.value_)

        def __floor__(self):
            warnings.warn(f"__floor__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return floor(self.value_)

        def __ceil__(self):
            warnings.warn(f"__ceil__ is depreciated on {{cls_name}} and will be removed in the future. Please use .py_float to achieve the same behaviour.", DeprecationWarning)
            return ceil(self.value_)