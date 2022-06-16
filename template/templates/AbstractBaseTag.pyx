{{py:
from template import include
try:
    show_eq
except:
    show_eq = True
}}
    def __str__({{cls_name}} self):
        return str(self.value_)
{{include("Eq.pyx", **locals()) if show_eq else ""}}
    def __reduce__({{cls_name}} self):
        return self.__class__, (self.value_,)

    def __deepcopy__({{cls_name}} self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__({{cls_name}} self):
        return self.__class__(self.value_)