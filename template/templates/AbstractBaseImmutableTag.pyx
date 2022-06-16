{{py:from template import include}}
{{include("AbstractBaseTag.pyx", **locals())}}

    def __hash__({{cls_name}} self):
        return hash((self.tag_id, self.value_))

    def __ge__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ >= other_.value_
        elif __major__ <= 2:
            warnings.warn("NBT comparison operator (a >= b) will only return True between classes of the same type.", FutureWarning)
            return self.value_ >= primitive_conversion(other)
        return NotImplemented

    def __gt__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ > other_.value_
        elif __major__ <= 2:
            warnings.warn("NBT comparison operator (a > b) will only return True between classes of the same type.", FutureWarning)
            return self.value_ > primitive_conversion(other)
        return NotImplemented

    def __le__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ <= other_.value_
        elif __major__ <= 2:
            warnings.warn("NBT comparison operator (a <= b) will only return True between classes of the same type.", FutureWarning)
            return self.value_ <= primitive_conversion(other)
        return NotImplemented

    def __lt__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ < other_.value_
        elif __major__ <= 2:
            warnings.warn("NBT comparison operator (a == b) will only return True between classes of the same type.", FutureWarning)
            return self.value_ < primitive_conversion(other)
        return NotImplemented