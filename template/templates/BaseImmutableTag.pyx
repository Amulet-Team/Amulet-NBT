{{py:from template import include}}
{{include("BaseTag.pyx", cls_name=cls_name)}}

    @property
    def py_data({{cls_name}} self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

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