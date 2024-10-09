#include <stdexcept>
#include <vector>
#include <memory>
#include <string>
#include <bit>
#include <variant>
#include <cstdint>
#include <fstream>

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>
#include <pybind11/numpy.h>

#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/copy.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>
#include <amulet_nbt/pybind/serialisation.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;


#define PyArray(CLSNAME, ELEMENTCLS, BITCOUNT, TAGID)\
    py::class_<AmuletNBT::CLSNAME, std::shared_ptr<AmuletNBT::CLSNAME>> CLSNAME(m, #CLSNAME, AbstractBaseArrayTag, py::buffer_protocol(),\
        "This class stores a fixed size signed "#BITCOUNT" bit vector."\
    );\
    CLSNAME.def_property_readonly_static("tag_id", [](py::object) {return TAGID;});\
    CLSNAME.def(\
        py::init([asarray, dtype](py::object value) {\
            /* Is there a better way to do this? */\
            py::array arr = asarray(value, dtype("int"#BITCOUNT)).attr("ravel")().cast<py::array>();\
            std::vector<ELEMENTCLS> v = arr.cast<std::vector<ELEMENTCLS>> ();\
            return std::make_shared<AmuletNBT::CLSNAME>(v.begin(), v.end());\
        }),\
        py::arg("value") = py::tuple(),\
        py::doc("__init__(self: amulet_nbt."#CLSNAME", value: collections.abc.Iterable[typing.SupportsInt] = ()) -> None")\
    );\
    CLSNAME.def_buffer(\
        [](AmuletNBT::CLSNAME& self) -> py::buffer_info {\
            return py::buffer_info(\
                self.data(),\
                sizeof(ELEMENTCLS),\
                py::format_descriptor<ELEMENTCLS>::format(),\
                1,\
                {self.size()},\
                {sizeof(ELEMENTCLS)}\
            );\
        }\
    );\
    CLSNAME.def_property_readonly(\
        "np_array",\
        [asarray](const AmuletNBT::CLSNAME& self){\
            return asarray(self);\
        },\
        py::doc(\
            "A numpy array holding the same internal data.\n"\
            "\n"\
            "Changes to the array will also modify the internal state."\
        )\
    );\
    CLSNAME.def_property_readonly(\
        "py_data",\
        [asarray](const AmuletNBT::CLSNAME& self){\
            return asarray(self);\
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
            std::string out = #CLSNAME "([";\
            for (size_t i = 0; i < self.size(); i++){\
                if (i){\
                    out += ", ";\
                };\
                out += std::to_string(self[i]);\
            };\
            out += "])";\
            return out;\
        }\
    );\
    CLSNAME.def(\
        "__str__",\
        [](const AmuletNBT::CLSNAME& self){\
            std::string out = "[";\
            for (size_t i = 0; i < self.size(); i++){\
                if (i){\
                    out += ", ";\
                };\
                out += std::to_string(self[i]);\
            };\
            out += "]";\
            return out;\
        }\
    );\
    CLSNAME.def(\
        py::pickle(\
            [](const AmuletNBT::CLSNAME& self){\
                return py::bytes(AmuletNBT::write_nbt("", self, std::endian::big, AmuletNBT::utf8_to_mutf8));\
            },\
            [](py::bytes state){\
                return std::get<AmuletNBT::CLSNAME##Ptr>(\
                    AmuletNBT::read_nbt(state, std::endian::big, AmuletNBT::mutf8_to_utf8).tag_node\
                );\
            }\
        )\
    );\
    CLSNAME.def(\
        "__copy__",\
        [](const AmuletNBT::CLSNAME& self){\
            return NBTTag_copy<AmuletNBT::CLSNAME>(self);\
        }\
    );\
    CLSNAME.def(\
        "__deepcopy__",\
        [](const AmuletNBT::CLSNAME& self, py::dict){\
            return AmuletNBT::NBTTag_copy<AmuletNBT::CLSNAME>(self);\
        },\
        py::arg("memo")\
    );\
    CLSNAME.def(\
        "__eq__",\
        [](const AmuletNBT::CLSNAME& self, const AmuletNBT::CLSNAME& other){\
            return self == other;\
        },\
        py::is_operator()\
    );\
    CLSNAME.def(\
        "__len__",\
        [](const AmuletNBT::CLSNAME& self){\
            return self.size();\
        }\
    );\
    CLSNAME.def(\
        "__iter__",\
        [](const AmuletNBT::CLSNAME& self) {return py::make_iterator(self.begin(), self.end());},\
        py::keep_alive<0, 1>() /* Essential: keep object alive while iterator exists */);\
    CLSNAME.def(\
        "__reversed__",\
        [](const AmuletNBT::CLSNAME& self) {return py::make_iterator(self.rbegin(), self.rend());},\
        py::keep_alive<0, 1>() /* Essential: keep object alive while iterator exists */);\
    CLSNAME.def(\
        "__getitem__",\
        [asarray](const AmuletNBT::CLSNAME& self, py::object item){\
            return asarray(self).attr("__getitem__")(item);\
        }\
    );\
    CLSNAME.def(\
        "__setitem__",\
        [asarray](const AmuletNBT::CLSNAME& self, py::object item, py::object value){\
            asarray(self)[item] = value;\
        }\
    );\
    CLSNAME.def(\
        "__contains__",\
        [asarray](const AmuletNBT::CLSNAME& self, py::object value){\
            asarray(self).contains(value);\
        }\
    );


void init_array(py::module& m) {
    py::object asarray = py::module::import("numpy").attr("asarray");
    py::object dtype = py::module::import("numpy").attr("dtype");
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");
    py::object compress = py::module::import("gzip").attr("compress");
    py::object AbstractBaseArrayTag = m.attr("AbstractBaseArrayTag");
    PyArray(ByteArrayTag, std::int8_t, 8, 7)
    PyArray(IntArrayTag, std::int32_t, 32, 11)
    PyArray(LongArrayTag, std::int64_t, 64, 12)
};
