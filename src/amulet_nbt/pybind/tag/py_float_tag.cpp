#include <string>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/wrapper.hpp>

namespace py = pybind11;


#define PyFloat(CLSNAME, PRECISION, TAGID)\
    py::class_<AmuletNBT::CLSNAME##Wrapper, AmuletNBT::AbstractBaseFloatTag> CLSNAME(m, #CLSNAME,\
        "A "#PRECISION" precision float class."\
    );\
    CLSNAME.def_property_readonly_static("tag_id", [](py::object) {return TAGID;});\
    CLSNAME.def(\
        py::init([](py::object value) {\
            try {\
                return AmuletNBT::CLSNAME##Wrapper(value.cast<AmuletNBT::CLSNAME>());\
            } catch (const py::cast_error&){\
                throw py::type_error("value must be float or float-like");\
            }\
        }),\
        py::arg("value") = 0.0,\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: typing.SupportsFloat) -> None")\
    );\
    CLSNAME.def_readonly(\
        "py_float",\
        &AmuletNBT::CLSNAME##Wrapper::tag,\
        py::doc(\
            "A python float representation of the class.\n"\
            "\n"\
            "The returned data is immutable so changes will not mirror the instance."\
        )\
    );\
    CLSNAME.def_readonly(\
        "py_data",\
        &AmuletNBT::CLSNAME##Wrapper::tag,\
        py::doc(\
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name.\n"\
        )\
    );\
    CLSNAME.def(\
        "__repr__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self){\
            return #CLSNAME "(" + py::repr(py::cast(self.tag)).cast<std::string>() + ")";\
        }\
    );\
    CLSNAME.def(\
        "__str__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self){\
            return py::repr(py::cast(self.tag));\
        }\
    );\
    CLSNAME.def(\
        py::pickle(\
            [](const AmuletNBT::CLSNAME##Wrapper& self){\
                return self.tag;\
            },\
            [](AmuletNBT::CLSNAME state){\
                return AmuletNBT::CLSNAME##Wrapper(state);\
            }\
        )\
    );\
    CLSNAME.def(\
        "__copy__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self){\
            return self;\
        }\
    );\
    CLSNAME.def(\
        "__deepcopy__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self, py::dict){\
            return self;\
        },\
        py::arg("memo")\
    );\
    CLSNAME.def(\
        "__hash__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self){\
            return py::hash(py::make_tuple(TAGID, self.tag));\
        }\
    );\
    CLSNAME.def(\
        "__int__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self) -> py::int_ {\
            return py::cast(self.tag);\
        }\
    );\
    CLSNAME.def(\
        "__float__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self) {\
            return self.tag;\
        }\
    );\
    CLSNAME.def(\
        "__bool__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self){\
            return self.tag != 0.0;\
        }\
    );\
    CLSNAME.def(\
        "__eq__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self, const AmuletNBT::CLSNAME##Wrapper& other){\
            return self.tag == other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__ge__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self, const AmuletNBT::CLSNAME##Wrapper& other){\
            return self.tag >= other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__gt__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self, const AmuletNBT::CLSNAME##Wrapper& other){\
            return self.tag > other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__le__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self, const AmuletNBT::CLSNAME##Wrapper& other){\
            return self.tag <= other.tag;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__lt__",\
        [](const AmuletNBT::CLSNAME##Wrapper& self, const AmuletNBT::CLSNAME##Wrapper& other){\
            return self.tag < other.tag;\
        },\
        py::is_operator()\
    );


void init_float(py::module& m) {
    PyFloat(FloatTag, single, 5)
    PyFloat(DoubleTag, double, 6)
}
