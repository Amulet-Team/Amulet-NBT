
    def __eq__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ == other_.value_
        elif __major__ <= 2:
            warnings.warn("NBT comparison operator (a == b) will only return True between classes of the same type.", FutureWarning)
        return NotImplemented
