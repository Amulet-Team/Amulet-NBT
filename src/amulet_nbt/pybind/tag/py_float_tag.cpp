#include <string>
#include <fstream>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>
#include <amulet_nbt/pybind/serialisation.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;


#define PyFloat(NATIVE, CLSNAME, PRECISION, TAGID)\
    py::class_<AmuletNBT::CLSNAME, AmuletNBT::AbstractBaseFloatTag> CLSNAME(m, #CLSNAME,\
        "A "#PRECISION" precision float class."\
    );\
    CLSNAME.def_property_readonly_static("tag_id", [](py::object) {return TAGID;});\
    CLSNAME.def(\
        py::init([](py::object value) {\
            try {\
                return AmuletNBT::CLSNAME(value.cast<NATIVE>());\
            } catch (const py::cast_error&){\
                throw py::type_error("value must be float or float-like");\
            }\
        }),\
        py::arg("value") = 0.0,\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: typing.SupportsFloat) -> None")\
    );\
    CLSNAME.def_property_readonly(\
        "py_float",\
        [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
            return self;\
        },\
        py::doc(\
            "A python float representation of the class.\n"\
            "\n"\
            "The returned data is immutable so changes will not mirror the instance."\
        )\
    );\
    CLSNAME.def_property_readonly(\
        "py_data",\
        [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
            return self;\
        },\
        py::doc(\
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"\
            "\n"\
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"\
            "This is here for convenience to get a python representation under the same property name.\n"\
        )\
    );\
    SerialiseTag(CLSNAME)\
    CLSNAME.def(\
        "__repr__",\
        [](const AmuletNBT::CLSNAME& self){\
            return #CLSNAME "(" + py::repr(py::cast(static_cast<NATIVE>(self))).cast<std::string>() + ")";\
        }\
    );\
    CLSNAME.def(\
        "__str__",\
        [](const AmuletNBT::CLSNAME& self){\
            return py::repr(py::cast(static_cast<NATIVE>(self)));\
        }\
    );\
    CLSNAME.def(\
        py::pickle(\
            [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
                return self;\
            },\
            [](NATIVE state){\
                return AmuletNBT::CLSNAME(state);\
            }\
        )\
    );\
    CLSNAME.def(\
        "__copy__",\
        [](const AmuletNBT::CLSNAME& self){\
            return self;\
        }\
    );\
    CLSNAME.def(\
        "__deepcopy__",\
        [](const AmuletNBT::CLSNAME& self, py::dict){\
            return self;\
        },\
        py::arg("memo")\
    );\
    CLSNAME.def(\
        "__hash__",\
        [](const AmuletNBT::CLSNAME& self){\
            return py::hash(py::make_tuple(TAGID, static_cast<NATIVE>(self)));\
        }\
    );\
    CLSNAME.def(\
        "__int__",\
        [](const AmuletNBT::CLSNAME& self) -> py::int_ {\
            return py::cast(static_cast<NATIVE>(self));\
        }\
    );\
    CLSNAME.def(\
        "__float__",\
        [](const AmuletNBT::CLSNAME& self) -> NATIVE {\
            return self;\
        }\
    );\
    CLSNAME.def(\
        "__bool__",\
        [](const AmuletNBT::CLSNAME& self){\
            return self != 0.0;\
        }\
    );\
    CLSNAME.def(\
        "__eq__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self == other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__ge__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self >= other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__gt__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self > other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__le__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self <= other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__lt__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self < other;\
        },\
        py::is_operator()\
    );


void init_float(py::module& m) {
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");
    py::object compress = py::module::import("gzip").attr("compress");
    PyFloat(float, FloatTag, single, 5)
    PyFloat(double, DoubleTag, double, 6)
}
