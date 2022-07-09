    cpdef {{tag_cls_name}} get_{{tag_name}}(self, int index):
        """Get the tag at index if it is a {{tag_cls_name}}.
    
        :param index: The index to get
        :return: The {{tag_cls_name}}.
        :raises: IndexError if the index is outside the list.
        :raises: TypeError if the stored type is not a {{tag_cls_name}}
        """
        cdef {{tag_cls_name}} tag = self[index]
        return tag
