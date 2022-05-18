{{py:from template import include}}
{{include("AbstractBaseTag.pyx", cls_name=cls_name)}}

    def __hash__({{cls_name}} self):
        return hash((self.tag_id, self.value_))

    def __ge__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ >= other_.value_
        return NotImplemented

    def __gt__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ > other_.value_
        return NotImplemented

    def __le__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ <= other_.value_
        return NotImplemented

    def __lt__({{cls_name}} self, other):
        cdef {{cls_name}} other_
        if isinstance(other, {{cls_name}}):
            other_ = other
            return self.value_ < other_.value_
        return NotImplemented