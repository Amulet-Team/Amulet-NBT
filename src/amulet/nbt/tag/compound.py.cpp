#include <bit>
#include <fstream>
#include <memory>
#include <string>
#include <unordered_map>
#include <utility>
#include <variant>
#include <vector>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/zlib/zlib.hpp>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/serialisation.py.hpp>
#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/copy.hpp>
#include <amulet/nbt/tag/eq.hpp>

namespace py = pybind11;

namespace Amulet {
namespace NBT {
    class CompoundTagIterator {
    private:
        CompoundTagPtr tag;
        const CompoundTag::iterator begin;
        const CompoundTag::iterator end;
        CompoundTag::iterator pos;
        size_t size;

    public:
        CompoundTagIterator(
            CompoundTagPtr tag)
            : tag(tag)
            , begin(tag->begin())
            , end(tag->end())
            , pos(tag->begin())
            , size(tag->size()) { };
        std::string next()
        {
            if (!is_valid()) {
                throw std::runtime_error("CompoundTag changed size during iteration.");
            }
            return (pos++)->first;
        };
        bool has_next()
        {
            return pos != end;
        };
        bool is_valid()
        {
            // This is not fool proof.
            // There are cases where this is true but the iterator is invalid.
            // The programmer should write good code and this will catch some of the bad cases.
            return size == tag->size() && begin == tag->begin() && end == tag->end();
        };
    };
} // namespace NBT
} // namespace Amulet

void CompoundTag_update(Amulet::NBT::CompoundTag& self, py::dict other)
{
    auto map = other.cast<Amulet::NBT::CompoundTagNative>();
    for (const auto& it : map) {
        self[it.first] = it.second;
    }
}

template <
    typename T,
    std::enable_if_t<!is_shared_ptr<T>::value, bool> = true>
T new_tag()
{
    return T();
}

template <
    typename T,
    std::enable_if_t<is_shared_ptr<T>::value, bool> = true>
T new_tag()
{
    return std::make_shared<typename T::element_type>();
}

void init_compound(py::module& m)
{
    py::class_<Amulet::NBT::CompoundTagIterator> CompoundTagIterator(m, "CompoundTagIterator");
    CompoundTagIterator.def(
        "__next__",
        [](Amulet::NBT::CompoundTagIterator& self) -> py::object {
            if (self.has_next()) {
                std::string key = self.next();
                try {
                    return py::str(key);
                } catch (py::error_already_set&) {
                    return py::bytes(key);
                }
            }
            throw py::stop_iteration("");
        });
    CompoundTagIterator.def(
        "__iter__",
        [](Amulet::NBT::CompoundTagIterator& self) {
            return self;
        });

    py::object AbstractBaseTag = m.attr("AbstractBaseTag");
    py::object AbstractBaseMutableTag = m.attr("AbstractBaseMutableTag");
    py::object isinstance = py::module::import("builtins").attr("isinstance");
    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");

    // py::class_<Amulet::NBT::CompoundTag, Amulet::NBT::AbstractBaseMutableTag, std::shared_ptr<Amulet::NBT::CompoundTag>> CompoundTag(m, "CompoundTag",
    py::class_<Amulet::NBT::CompoundTag, std::shared_ptr<Amulet::NBT::CompoundTag>> CompoundTag(m, "CompoundTag", AbstractBaseMutableTag,
        "A Python wrapper around a C++ unordered map.\n"
        "\n"
        "Note that this class is not thread safe and inherits all the limitations of a C++ unordered_map.");
    CompoundTag.def_property_readonly_static("tag_id", [](py::object) { return 10; });
    CompoundTag.def(
        py::init([](py::object value, const py::kwargs& kwargs) {
            Amulet::NBT::CompoundTagPtr tag = std::make_shared<Amulet::NBT::CompoundTag>();
            CompoundTag_update(*tag, py::dict(value));
            CompoundTag_update(*tag, kwargs);
            return tag;
        }),
        py::arg("value") = py::tuple());
    auto py_getter = [](const Amulet::NBT::CompoundTag& self) {
        py::dict out;
        for (const auto& it : self) {
            py::object value = py::cast(it.second);
            try {
                py::str key = py::str(it.first);
                out[key] = value;
            } catch (py::error_already_set&) {
                py::bytes key = py::bytes(it.first);
                out[key] = value;
            }
        }
        return out;
    };
    CompoundTag.def_property_readonly(
        "py_dict",
        py_getter,
        py::doc("A shallow copy of the CompoundTag as a python dictionary."));
    CompoundTag.def_property_readonly(
        "py_data",
        py_getter,
        py::doc(
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
            "\n"
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
            "This is here for convenience to get a python representation under the same property name.\n"));
    SerialiseTag(CompoundTag)
        CompoundTag.def(
            "__repr__",
            [](const Amulet::NBT::CompoundTag& self) {
                std::string out;
                out += "CompoundTag({";
                for (auto it = self.begin(); it != self.end(); it++) {
                    if (it != self.begin()) {
                        out += ", ";
                    }
                    try {
                        out += py::repr(py::str(it->first));
                    } catch (py::error_already_set&) {
                        out += py::repr(py::bytes(it->first));
                    }
                    out += ": ";
                    out += py::repr(py::cast(it->second));
                }
                out += "})";
                return out;
            });
    CompoundTag.def(
        py::pickle(
            [](const Amulet::NBT::CompoundTag& self) {
                return py::bytes(Amulet::NBT::encode_nbt("", self, std::endian::big, Amulet::NBT::utf8_to_mutf8));
            },
            [](py::bytes state) {
                return std::get<Amulet::NBT::CompoundTagPtr>(
                    Amulet::NBT::decode_nbt(state, std::endian::big, Amulet::NBT::mutf8_to_utf8).tag_node);
            }));
    CompoundTag.def(
        "__copy__",
        [](const Amulet::NBT::CompoundTag& self) {
            return shallow_copy(self);
        });
    CompoundTag.def(
        "__deepcopy__",
        [](const Amulet::NBT::CompoundTag& self, py::dict) {
            return deep_copy(self);
        },
        py::arg("memo"));
    CompoundTag.def(
        "__str__",
        [](const Amulet::NBT::CompoundTag& self) {
            return py::str(py::dict(py::cast(self)));
        });
    CompoundTag.def(
        "__eq__",
        [](const Amulet::NBT::CompoundTag& self, const Amulet::NBT::CompoundTag& other) {
            return Amulet::NBT::NBTTag_eq(self, other);
        },
        py::is_operator());
    CompoundTag.def(
        "__len__",
        [](const Amulet::NBT::CompoundTag& self) {
            return self.size();
        });
    CompoundTag.def(
        "__bool__",
        [](const Amulet::NBT::CompoundTag& self) {
            return !self.empty();
        });
    CompoundTag.def(
        "__iter__",
        [](const Amulet::NBT::CompoundTagPtr self) {
            return Amulet::NBT::CompoundTagIterator(self);
        });
    CompoundTag.def(
        "__getitem__",
        [](const Amulet::NBT::CompoundTag& self, std::string key) {
            auto it = self.find(key);
            if (it == self.end()) {
                throw py::key_error(key);
            }
            return it->second;
        });
    CompoundTag.def(
        "get",
        [isinstance](const Amulet::NBT::CompoundTag& self, std::string key, py::object default_, py::object cls) -> py::object {
            auto it = self.find(key);
            if (it == self.end()) {
                return default_;
            }
            py::object tag = py::cast(it->second);
            if (isinstance(tag, cls)) {
                return tag;
            } else {
                return default_;
            }
        },
        py::arg("key"), py::arg("default") = py::none(), py::arg("cls") = AbstractBaseTag,
        py::doc(
            "Get an item from the CompoundTag.\n"
            "\n"
            ":param key: The key to get\n"
            ":param default: The value to return if the key does not exist or the type is wrong.\n"
            ":param cls: The class that the stored tag must inherit from. If the type is incorrect default is returned.\n"
            ":return: The tag stored in the CompoundTag if the type is correct else default.\n"
            ":raises: KeyError if the key does not exist.\n"
            ":raises: TypeError if the stored type is not a subclass of cls."));
    CompoundTag.def(
        "__contains__",
        [](const Amulet::NBT::CompoundTag& self, std::string key) {
            auto it = self.find(key);
            return it != self.end();
        });
    py::object KeysView = py::module::import("collections.abc").attr("KeysView");
    CompoundTag.def(
        "keys",
        [KeysView](const Amulet::NBT::CompoundTag& self) {
            return KeysView(py::cast(self));
        });
    py::object ItemsView = py::module::import("collections.abc").attr("ItemsView");
    CompoundTag.def(
        "items",
        [ItemsView](const Amulet::NBT::CompoundTag& self) {
            return ItemsView(py::cast(self));
        });
    py::object ValuesView = py::module::import("collections.abc").attr("ValuesView");
    CompoundTag.def(
        "values",
        [ValuesView](const Amulet::NBT::CompoundTag& self) {
            return ValuesView(py::cast(self));
        });
    CompoundTag.def(
        "__setitem__",
        [](Amulet::NBT::CompoundTag& self, std::string key, Amulet::NBT::TagNode value) {
            self[key] = value;
        });
    CompoundTag.def(
        "__delitem__",
        [](Amulet::NBT::CompoundTag& self, std::string key) {
            auto it = self.find(key);
            if (it == self.end()) {
                throw py::key_error(key);
            }
            self.erase(it);
        });
    py::object marker = py::module::import("builtins").attr("object")();
    CompoundTag.def(
        "pop",
        [marker](Amulet::NBT::CompoundTag& self, std::string key, py::object default_) -> py::object {
            auto it = self.find(key);
            if (it == self.end()) {
                if (default_.is(marker)) {
                    throw py::key_error(key);
                } else {
                    return default_;
                }
            }
            Amulet::NBT::TagNode tag = it->second;
            self.erase(it);
            return py::cast(tag);
        },
        py::arg("key"), py::arg("default") = marker);
    CompoundTag.def(
        "popitem",
        [](Amulet::NBT::CompoundTag& self) -> std::pair<std::variant<py::str, py::bytes>, Amulet::NBT::TagNode> {
            auto it = self.begin();
            if (it == self.end()) {
                throw py::key_error("CompoundTag is empty.");
            }
            std::string key = it->first;
            Amulet::NBT::TagNode value = it->second;
            self.erase(it);
            try {
                py::str py_key = py::str(key);
                return std::make_pair(py_key, value);
            } catch (py::error_already_set&) {
                py::bytes py_key = py::bytes(key);
                return std::make_pair(py_key, value);
            }
        });
    CompoundTag.def(
        "clear",
        [](Amulet::NBT::CompoundTag& self) {
            self.clear();
        });
    CompoundTag.def(
        "update",
        [](Amulet::NBT::CompoundTag& self, py::object other, const py::kwargs& kwargs) {
            CompoundTag_update(self, py::dict(other));
            CompoundTag_update(self, kwargs);
        },
        py::arg("other") = py::tuple(), py::pos_only());
    CompoundTag.def(
        "setdefault",
        [isinstance](Amulet::NBT::CompoundTag& self, std::string key, std::variant<std::monostate, Amulet::NBT::TagNode> tag, py::object cls) -> py::object {
            auto set_value = [&self, &key, &tag]() {
                return std::visit([&self, &key](auto&& value) -> py::object {
                    using T = std::decay_t<decltype(value)>;
                    if constexpr (std::is_same_v<T, std::monostate>) {
                        throw py::type_error("Cannot setdefault a value of None.");
                    } else {
                        self[key] = value;
                        return py::cast(value);
                    }
                },
                    tag);
            };
            auto it = self.find(key);
            if (it == self.end()) {
                return set_value();
            }
            py::object existing_tag = py::cast(it->second);
            if (!isinstance(existing_tag, cls)) {
                // if the key exists but has the wrong type then set it
                return set_value();
            }
            return existing_tag;
        },
        py::arg("key"), py::arg("tag") = py::none(), py::arg("cls") = AbstractBaseTag);
    CompoundTag.def_static(
        "fromkeys",
        [](py::object keys, Amulet::NBT::TagNode value) {
            Amulet::NBT::CompoundTagPtr tag = std::make_shared<Amulet::NBT::CompoundTag>();
            for (std::string& key : keys.cast<std::vector<std::string>>()) {
                (*tag)[key] = value;
            }
            return tag;
        });

#define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)                                                                           \
    CompoundTag.def(                                                                                                             \
        "get_" TAG_NAME,                                                                                                         \
        [](                                                                                                                      \
            const Amulet::NBT::CompoundTag& self,                                                                                \
            std::string key,                                                                                                     \
            std::variant<std::monostate, TAG_STORAGE> default_,                                                                  \
            bool raise_errors) -> std::variant<std::monostate, TAG_STORAGE> {                                                    \
            auto it = self.find(key);                                                                                            \
            if (it == self.end()) {                                                                                              \
                if (raise_errors) {                                                                                              \
                    throw pybind11::key_error(key);                                                                              \
                } else {                                                                                                         \
                    return default_;                                                                                             \
                }                                                                                                                \
            }                                                                                                                    \
            py::object tag = py::cast(it->second);                                                                               \
            if (py::isinstance<Amulet::NBT::TAG>(tag)) {                                                                         \
                return tag.cast<TAG_STORAGE>();                                                                                  \
            } else if (raise_errors) {                                                                                           \
                throw pybind11::type_error(key);                                                                                 \
            } else {                                                                                                             \
                return default_;                                                                                                 \
            }                                                                                                                    \
        },                                                                                                                       \
        py::arg("key"), py::arg("default") = py::none(), py::arg("raise_errors") = false,                                        \
        py::doc(                                                                                                                 \
            "Get the tag stored in key if it is a " #TAG ".\n"                                                                   \
            "\n"                                                                                                                 \
            ":param key: The key to get\n"                                                                                       \
            ":param default: The value to return if the key does not exist or the type is wrong.\n"                              \
            ":param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.\n" \
            ":return: The " #TAG ".\n"                                                                                           \
            ":raises: KeyError if the key does not exist and raise_errors is True.\n"                                            \
            ":raises: TypeError if the stored type is not a " #TAG " and raise_errors is True."));                               \
    CompoundTag.def(                                                                                                             \
        "setdefault_" TAG_NAME,                                                                                                  \
        [isinstance](                                                                                                            \
            Amulet::NBT::CompoundTag& self,                                                                                      \
            std::string key,                                                                                                     \
            std::variant<std::monostate, TAG_STORAGE> default_) -> std::variant<std::monostate, TAG_STORAGE> {                   \
            auto set_and_return = [&self, &key](TAG_STORAGE tag) {                                                               \
                self[key] = tag;                                                                                                 \
                return tag;                                                                                                      \
            };                                                                                                                   \
            auto create_set_return = [set_and_return, &default_]() {                                                             \
                return std::visit([set_and_return](auto&& tag) {                                                                 \
                    using T = std::decay_t<decltype(tag)>;                                                                       \
                    if constexpr (std::is_same_v<T, std::monostate>) {                                                           \
                        return set_and_return(new_tag<TAG_STORAGE>());                                                           \
                    } else {                                                                                                     \
                        return set_and_return(tag);                                                                              \
                    }                                                                                                            \
                },                                                                                                               \
                    default_);                                                                                                   \
            };                                                                                                                   \
            auto it = self.find(key);                                                                                            \
            if (it == self.end()) {                                                                                              \
                return create_set_return();                                                                                      \
            }                                                                                                                    \
            py::object existing_tag = py::cast(it->second);                                                                      \
            if (py::isinstance<Amulet::NBT::TAG>(existing_tag)) {                                                                \
                return existing_tag.cast<TAG_STORAGE>();                                                                         \
            } else {                                                                                                             \
                /* if the key exists but has the wrong type then set it */                                                       \
                return create_set_return();                                                                                      \
            }                                                                                                                    \
        },                                                                                                                       \
        py::arg("key"), py::arg("default") = py::none(),                                                                         \
        py::doc(                                                                                                                 \
            "Populate key if not defined or value is not " #TAG ". Return the value stored\n."                                   \
            "\n"                                                                                                                 \
            "If default is a " #TAG " then it will be stored under key else a default instance will be created.\n"               \
            "\n"                                                                                                                 \
            ":param key: The key to populate and get\n"                                                                          \
            ":param default: The default value to use. If None, the default " #TAG " is used.\n"                                 \
            ":return: The " #TAG " stored in key"));                                                                             \
    CompoundTag.def(                                                                                                             \
        "pop_" TAG_NAME,                                                                                                         \
        [marker](                                                                                                                \
            Amulet::NBT::CompoundTag& self,                                                                                      \
            std::string key,                                                                                                     \
            std::variant<std::monostate, TAG_STORAGE> default_,                                                                  \
            bool raise_errors) -> std::variant<std::monostate, TAG_STORAGE> {                                                    \
            auto it = self.find(key);                                                                                            \
            if (it == self.end()) {                                                                                              \
                if (raise_errors) {                                                                                              \
                    throw py::key_error(key);                                                                                    \
                } else {                                                                                                         \
                    return default_;                                                                                             \
                }                                                                                                                \
            }                                                                                                                    \
            py::object existing_tag = py::cast(it->second);                                                                      \
            if (py::isinstance<Amulet::NBT::TAG>(existing_tag)) {                                                                \
                self.erase(it);                                                                                                  \
                return existing_tag.cast<TAG_STORAGE>();                                                                         \
            } else if (raise_errors) {                                                                                           \
                throw pybind11::type_error(key);                                                                                 \
            } else {                                                                                                             \
                return default_;                                                                                                 \
            }                                                                                                                    \
        },                                                                                                                       \
        py::arg("key"), py::arg("default") = py::none(), py::arg("raise_errors") = false,                                        \
        py::doc(                                                                                                                 \
            "Remove the specified key and return the corresponding value if it is a " #TAG ".\n"                                 \
            "\n"                                                                                                                 \
            "If the key exists but the type is incorrect, the value will not be removed.\n"                                      \
            "\n"                                                                                                                 \
            ":param key: The key to get and remove\n"                                                                            \
            ":param default: The value to return if the key does not exist or the type is wrong.\n"                              \
            ":param raise_errors: If True, KeyError and TypeError are raise on error. If False, default is returned on error.\n" \
            ":return: The " #TAG ".\n"                                                                                           \
            ":raises: KeyError if the key does not exist and raise_errors is True.\n"                                            \
            ":raises: TypeError if the stored type is not a " #TAG " and raise_errors is True."));

    FOR_EACH_LIST_TAG(CASE)
#undef CASE
}
