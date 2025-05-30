#include <bit>
#include <fstream>
#include <ios>
#include <memory>
#include <stdexcept>
#include <string>
#include <variant>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/zlib/zlib.hpp>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/copy.hpp>
#include <amulet/nbt/tag/eq.hpp>
#include <amulet/nbt/tag/named_tag.hpp>

namespace py = pybind11;

namespace AmuletPy {
class NamedTagIterator {
private:
    py::object named_tag;
    size_t index;

public:
    NamedTagIterator(py::object named_tag)
        : named_tag(named_tag)
        , index(0)
    {
    }
    py::object next()
    {
        switch (index) {
        case 0:
            index++;
            return named_tag.attr("name");
        case 1:
            index++;
            return named_tag.attr("tag");
        default:
            throw pybind11::stop_iteration("");
        }
    }
};
}

void init_named_tag(py::module& m)
{
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    py::class_<AmuletPy::NamedTagIterator> NamedTagIterator(m, "NamedTagIterator");
    NamedTagIterator.def(
        "__next__",
        &AmuletPy::NamedTagIterator::next);
    NamedTagIterator.def(
        "__iter__",
        [](AmuletPy::NamedTagIterator& self) {
            return self;
        });

    py::class_<Amulet::NBT::NamedTag, std::shared_ptr<Amulet::NBT::NamedTag>> NamedTag(m, "NamedTag");
    NamedTag.def(
        py::init([](std::variant<std::monostate, Amulet::NBT::TagNode> value, std::string name) {
            return std::visit([&name](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    return Amulet::NBT::NamedTag(name, std::make_shared<Amulet::NBT::CompoundTag>());
                } else {
                    return Amulet::NBT::NamedTag(name, tag);
                }
            },
                value);
        }),
        py::arg("tag") = py::none(), py::arg("name") = "");
    NamedTag.def_property(
        "name",
        [](const Amulet::NBT::NamedTag& self) -> py::object {
            try {
                return py::str(self.name);
            } catch (py::error_already_set&) {
                return py::bytes(self.name);
            }
        },
        [](Amulet::NBT::NamedTag& self, std::string name) {
            self.name = name;
        });
    NamedTag.def_property(
        "tag",
        [](const Amulet::NBT::NamedTag& self) {
            return self.tag_node;
        },
        [](Amulet::NBT::NamedTag& self, Amulet::NBT::TagNode tag) {
            self.tag_node = tag;
        });
    auto to_nbt = [](
                      const Amulet::NBT::NamedTag& self,
                      bool compressed,
                      std::endian endianness,
                      Amulet::StringEncoder string_encoder) -> py::bytes {
        std::string data;
        {
            py::gil_scoped_release nogil;
            data = Amulet::NBT::encode_nbt(self.name, self.tag_node, endianness, string_encoder);
            if (compressed) {
                std::string data2;
                Amulet::zlib::compress_gzip(data, data2);
                data = std::move(data2);
            }
        }
        return data;
    };
    NamedTag.def(
        "to_nbt",
        [to_nbt](
            const Amulet::NBT::NamedTag& self,
            Amulet::NBT::EncodingPreset preset) {
            return to_nbt(
                self,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.encode);
        },
        py::kw_only(),
        py::arg("preset") = java_encoding);
    NamedTag.def(
        "to_nbt",
        [to_nbt](
            const Amulet::NBT::NamedTag& self,
            bool compressed,
            bool little_endian,
            Amulet::NBT::StringEncoding string_encoding) {
            return to_nbt(
                self,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.encode);
        },
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding);
    auto save_to = [to_nbt](
                       const Amulet::NBT::NamedTag& self,
                       py::object filepath_or_writable,
                       bool compressed,
                       std::endian endianness,
                       Amulet::StringEncoder string_encoder) {
        py::bytes py_data = to_nbt(self, compressed, endianness, string_encoder);
        if (!filepath_or_writable.is(py::none())) {
            if (py::isinstance<py::str>(filepath_or_writable)) {
                std::string data = py_data.cast<std::string>();
                std::ofstream file(filepath_or_writable.cast<std::string>(), std::ios::out | std::ios::binary | std::ios::trunc);
                file.write(data.c_str(), data.size());
            } else {
                filepath_or_writable.attr("write")(py_data);
            }
        }
        return py_data;
    };
    NamedTag.def(
        "save_to",
        [save_to](
            const Amulet::NBT::NamedTag& self,
            py::object filepath_or_writable,
            Amulet::NBT::EncodingPreset preset) {
            return save_to(
                self,
                filepath_or_writable,
                preset.compressed,
                preset.endianness,
                preset.string_encoding.encode);
        },
        py::arg("filepath_or_writable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("preset") = java_encoding);
    NamedTag.def(
        "save_to",
        [save_to](
            const Amulet::NBT::NamedTag& self,
            py::object filepath_or_writable,
            bool compressed,
            bool little_endian,
            Amulet::NBT::StringEncoding string_encoding) {
            return save_to(
                self,
                filepath_or_writable,
                compressed,
                little_endian ? std::endian::little : std::endian::big,
                string_encoding.encode);
        },
        py::arg("filepath_or_writable") = py::none(),
        py::pos_only(),
        py::kw_only(),
        py::arg("compressed") = true,
        py::arg("little_endian") = false,
        py::arg("string_encoding") = mutf8_encoding);
    NamedTag.def(
        "to_snbt",
        [](
            const Amulet::NBT::NamedTag& self,
            py::object indent) {
            if (indent.is(py::none())) {
                return Amulet::NBT::encode_snbt(self.tag_node);
            } else if (py::isinstance<py::int_>(indent)) {
                return Amulet::NBT::encode_formatted_snbt(self.tag_node, std::string(indent.cast<size_t>(), ' '));
            } else if (py::isinstance<py::str>(indent)) {
                return Amulet::NBT::encode_formatted_snbt(self.tag_node, indent.cast<std::string>());
            } else {
                throw std::invalid_argument("indent must be None, int or str");
            }
        },
        py::arg("indent") = py::none());
    NamedTag.def(
        "__repr__",
        [](const Amulet::NBT::NamedTag& self) {
            std::string out;
            out += "NamedTag(";
            out += py::repr(py::cast(self.tag_node));
            out += ", ";
            try {
                out += py::repr(py::str(self.name));
            } catch (py::error_already_set&) {
                out += py::repr(py::bytes(self.name));
            }
            out += ")";
            return out;
        });
    NamedTag.def(
        py::pickle(
            [](const Amulet::NBT::NamedTag& self) {
                return py::bytes(Amulet::NBT::encode_nbt(self, std::endian::big, Amulet::NBT::utf8_to_mutf8));
            },
            [](py::bytes state) {
                return Amulet::NBT::decode_nbt(state, std::endian::big, Amulet::NBT::mutf8_to_utf8);
            }));
    NamedTag.def(
        "__copy__",
        [](const Amulet::NBT::NamedTag& self) {
            return shallow_copy(self);
        });
    NamedTag.def(
        "__deepcopy__",
        [](const Amulet::NBT::NamedTag& self, py::dict) {
            return deep_copy(self);
        },
        py::arg("memo"));
    NamedTag.def(
        "__eq__",
        [](const Amulet::NBT::NamedTag& self, const Amulet::NBT::NamedTag& other) {
            return self.name == other.name && Amulet::NBT::NBTTag_eq(self.tag_node, other.tag_node);
        },
        py::is_operator());
    NamedTag.def(
        "__getitem__",
        [](const Amulet::NBT::NamedTag& self, Py_ssize_t item) -> py::object {
            if (item < 0) {
                item += 2;
            }
            switch (item) {
            case 0:
                return py::cast(self).attr("name");
            case 1:
                return py::cast(self).attr("tag");
            default:
                throw std::out_of_range("Index out of range");
            }
        });
    NamedTag.def(
        "__iter__",
        [](const Amulet::NBT::NamedTag& self) {
            return AmuletPy::NamedTagIterator(py::cast(self));
        });

#define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)                 \
    NamedTag.def_property_readonly(                                    \
        TAG_NAME,                                                      \
        [](const Amulet::NBT::NamedTag& self) {                        \
            if (!std::holds_alternative<TAG_STORAGE>(self.tag_node)) { \
                throw pybind11::type_error("tag_node is not a " #TAG); \
            }                                                          \
            return std::get<TAG_STORAGE>(self.tag_node);               \
        },                                                             \
        py::doc(                                                       \
            "Get the tag if it is a " #TAG ".\n"                       \
            "\n"                                                       \
            ":return: The " #TAG ".\n"                                 \
            ":raises: TypeError if the stored type is not a " #TAG));

    FOR_EACH_LIST_TAG(CASE)
#undef CASE
}
