#include <amulet_nbt/tag/wrapper.hpp>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

namespace py = pybind11;

template <typename T>
void abstract_method(const T& self){
    PyErr_SetString(PyExc_NotImplementedError, "");
    throw py::error_already_set();
}


void init_abc(py::module& m) {
    py::class_<Amulet::AbstractBaseTag> AbstractBaseTag(m, "AbstractBaseTag",
        "Abstract Base Class for all tag classes"
    );
        AbstractBaseTag.def_property_readonly(
            "py_data",
            abstract_method<Amulet::AbstractBaseTag>,
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name."\
        );
        AbstractBaseTag.def(
            "to_nbt",
            abstract_method<Amulet::AbstractBaseTag>
        );
        AbstractBaseTag.def(
            "save_to",
            abstract_method<Amulet::AbstractBaseTag>
        );
        AbstractBaseTag.def(
            "to_snbt",
            abstract_method<Amulet::AbstractBaseTag>
        );
        AbstractBaseTag.def(
            "__eq__",
            abstract_method<Amulet::AbstractBaseTag>,
            "Check if the instance is equal to another instance.\n"
            "\n"
            "This will only return True if the tag type is the same and the data contained is the same."
        );
        AbstractBaseTag.def(
            "__repr__",
            abstract_method<Amulet::AbstractBaseTag>,
            "A string representation of the object to show how it can be constructed."
        );
        AbstractBaseTag.def(
            "__str__",
            abstract_method<Amulet::AbstractBaseTag>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__reduce__",
            abstract_method<Amulet::AbstractBaseTag>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__copy__",
            abstract_method<Amulet::AbstractBaseTag>,
            "A string representation of the object."
        );
        AbstractBaseTag.def(
            "__deepcopy__",
            abstract_method<Amulet::AbstractBaseTag>,
            "A string representation of the object."
        );

    py::class_<Amulet::AbstractBaseImmutableTag, Amulet::AbstractBaseTag> AbstractBaseImmutableTag(m, "AbstractBaseImmutableTag",
        "Abstract Base Class for all tag classes"
    );
        AbstractBaseImmutableTag.def(
            "__hash__",
            abstract_method<Amulet::AbstractBaseImmutableTag>,
            "A hash of the data in the class."
        );

    py::class_<Amulet::AbstractBaseNumericTag, Amulet::AbstractBaseImmutableTag> AbstractBaseNumericTag(m, "AbstractBaseNumericTag",
        "Abstract Base Class for all numeric tag classes"
    );
        AbstractBaseNumericTag.def(
            "__int__",
            abstract_method<Amulet::AbstractBaseNumericTag>,
            "Get a python int representation of the class."
        );
        AbstractBaseNumericTag.def(
            "__float__",
            abstract_method<Amulet::AbstractBaseNumericTag>,
            "Get a python float representation of the class."
        );
        AbstractBaseNumericTag.def(
            "__bool__",
            abstract_method<Amulet::AbstractBaseNumericTag>,
            "Get a python bool representation of the class."
        );

    py::class_<Amulet::AbstractBaseIntTag, Amulet::AbstractBaseNumericTag> AbstractBaseIntTag(m, "AbstractBaseIntTag",
        "Abstract Base Class for all int tag classes"
    );
        AbstractBaseIntTag.def_property_readonly(
            "py_int",
            abstract_method<Amulet::AbstractBaseTag>,
            "A python int representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."
        );

    py::class_<Amulet::AbstractBaseFloatTag, Amulet::AbstractBaseNumericTag> AbstractBaseFloatTag(m, "AbstractBaseFloatTag",
        "Abstract Base Class for all float tag classes."
    );
        AbstractBaseFloatTag.def_property_readonly(
            "py_float",
            abstract_method<Amulet::AbstractBaseTag>,
            "A python float representation of the class.\n"
            "\n"
            "The returned data is immutable so changes will not mirror the instance."
        );

    py::class_<Amulet::AbstractBaseMutableTag, Amulet::AbstractBaseTag> AbstractBaseMutableTag(m, "AbstractBaseMutableTag",
        "Abstract Base Class for all mutable tags."
    );
        AbstractBaseMutableTag.attr("__hash__") = py::none();

    py::class_<Amulet::AbstractBaseArrayTag, Amulet::AbstractBaseMutableTag> AbstractBaseArrayTag(m, "AbstractBaseArrayTag",
        "Abstract Base Class for all array tag classes."
    );
}
