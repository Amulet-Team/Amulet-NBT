    def __str__({{cls_name}} self):
        return str(self.value_)

    def __eq__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ == other_.value_
        return False

    def __reduce__({{cls_name}} self):
        return self.__class__, (self.value_,)

    def __deepcopy__({{cls_name}} self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__({{cls_name}} self):
        return self.__class__(self.value_)