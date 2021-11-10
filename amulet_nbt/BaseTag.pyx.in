    def __str__({{cls_name}} self):
        return str(self.value_)

    def __dir__({{cls_name}} self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__({{cls_name}} self, other):
        return self.value_ == other

    def __ge__({{cls_name}} self, other):
        return self.value_ >= other

    def __gt__({{cls_name}} self, other):
        return self.value_ > other

    def __le__({{cls_name}} self, other):
        return self.value_ <= other

    def __lt__({{cls_name}} self, other):
        return self.value_ < other

    def __reduce__({{cls_name}} self):
        return self.__class__, (self.value_,)

    def __deepcopy__({{cls_name}} self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__({{cls_name}} self):
        return self.__class__(self.value_)