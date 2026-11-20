#include <algorithm>
#include <array>
#include <bit>
#include <cstdint>
#include <fstream>
#include <limits>
#include <memory>
#include <stdexcept>
#include <string>
#include <variant>
#include <vector>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/pytypes.h>
#include <pybind11/stl.h>

#include <amulet/zlib/zlib.hpp>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/nbt_encoding/string.hpp>
#include <amulet/nbt/string_encoding/encoding.py.hpp>
#include <amulet/nbt/tag/abc.hpp>
#include <amulet/nbt/tag/copy.hpp>
#include <amulet/nbt/tag/eq.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/list_methods.hpp>
#include <amulet/nbt/tag/serialisation.py.hpp>

namespace py = pybind11;

namespace Amulet {
namespace NBT {
    // A class to emulate python's iteration mechanic
    class ListTagIterator {
    private:
        ListTagPtr tag;
        size_t index;
        std::ptrdiff_t step;

    public:
        ListTagIterator(ListTagPtr tag, size_t start, std::ptrdiff_t step)
            : tag(tag)
            , index(start)
            , step(step) { };
        TagNode next()
        {
            auto node = ListTag_get_node<size_t>(*tag, index);
            index += step;
            return node;
        }
        bool has_next()
        {
            return index >= 0 && index < ListTag_size(*tag);
        }
    };
} // namespace NBT
} // namespace Amulet

void ListTag_extend(Amulet::NBT::ListTag& tag, py::object value)
{
    // The caller must ensure value is not tag
    auto it = py::iter(value);
    while (it != py::iterator::sentinel()) {
        Amulet::NBT::TagNode node = py::cast<Amulet::NBT::TagNode>(*it);
        std::visit([&tag](auto&& node_tag) {
            using T = std::decay_t<decltype(node_tag)>;
            Amulet::NBT::ListTag_append<T>(tag, node_tag);
        },
            node);
        ++it;
    }
}

template <typename tagT>
void ListTag_set_slice(Amulet::NBT::ListTag& self, const py::slice& slice, std::vector<tagT>& vec)
{
    if (std::holds_alternative<std::vector<tagT>>(self)) {
        // Tag type matches
        std::vector<tagT>& list_tag = std::get<std::vector<tagT>>(self);
        Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
        if (!slice.compute(list_tag.size(), &start, &stop, &step, &slice_length)) {
            throw py::error_already_set();
        }
        if (vec.size() == slice_length) {
            // Size matches. Overwrite.
            for (auto& tag : vec) {
                list_tag[start] = tag;
                start += step;
            }
        } else if (step == 1) {
            // Erase the region and insert the new region
            list_tag.erase(
                list_tag.begin() + start,
                list_tag.begin() + stop);
            list_tag.insert(
                list_tag.begin() + start,
                vec.begin(),
                vec.end());
        } else {
            throw std::invalid_argument(
                "attempt to assign sequence of size " + std::to_string(vec.size()) + " to extended slice of size " + std::to_string(slice_length));
        }
    } else {
        // Tag type does not match
        size_t size = ListTag_size(self);
        Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
        if (!slice.compute(size, &start, &stop, &step, &slice_length)) {
            throw py::error_already_set();
        }
        if (size == slice_length) {
            // Overwriting all values
            if (step == -1) {
                // Reverse the element order
                std::reverse(vec.begin(), vec.end());
            } else if (step != 1) {
                throw std::invalid_argument(
                    "When overwriting values in a ListTag the types must match or all tags must be overwritten.");
            }
            self.emplace<std::vector<tagT>>(vec);
        } else {
            throw py::type_error("NBT ListTag item mismatch.");
        }
    }
}

template <typename tagT>
void ListTag_del_slice(std::vector<tagT>& self, const py::slice& slice)
{
    Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
    if (!slice.compute(self.size(), &start, &stop, &step, &slice_length)) {
        throw py::error_already_set();
    }
    if (step == 1) {
        self.erase(
            self.begin() + start,
            self.begin() + stop);
    } else if (step < 0) {
        for (Py_ssize_t i = 0; i < slice_length; i++) {
            self.erase(self.begin() + (start + step * i));
        }
    } else if (step > 0) {
        // erase values back to front
        for (Py_ssize_t i = 0; i < slice_length; i++) {
            self.erase(self.begin() + (start + step * (slice_length - 1 - i)));
        }
    } else {
        throw std::invalid_argument("slice step cannot be zero");
    }
}

class TagNodeT : public Amulet::NBT::TagNode {
public:
    using Amulet::NBT::TagNode::TagNode;
    using Amulet::NBT::TagNode::operator=;

    TagNodeT(const Amulet::NBT::TagNode& v)
        : Amulet::NBT::TagNode(v)
    {
    }
    TagNodeT(Amulet::NBT::TagNode&& v)
        : Amulet::NBT::TagNode(std::move(v))
    {
    }
};

namespace pybind11 {
namespace detail {
    template <>
    struct type_caster<::TagNodeT> {
        using Base = type_caster<Amulet::NBT::TagNode>;

        PYBIND11_TYPE_CASTER(::TagNodeT, const_name("TagT"));

        bool load(handle src, bool convert)
        {
            Base base;
            if (base.load(src, convert)) {
                value = std::move(*base);
                return true;
            }
            return false;
        }

        static handle cast(const ::TagNodeT& src, return_value_policy policy, handle parent)
        {
            return Base::cast(static_cast<const Amulet::NBT::TagNode&>(src), policy, parent);
        }

        static handle cast(::TagNodeT&& src, return_value_policy policy, handle parent)
        {
            return Base::cast(static_cast<Amulet::NBT::TagNode&&>(std::move(src)), policy, parent);
        }
    };
} // namespace detail
} // namespace pybind11

using Self = Amulet::pybind11_extensions::PyObjectStr<"typing.Self">;

void init_list(py::module& m, py::classh<Amulet::NBT::ListTag> ListTag)
{
    py::classh<Amulet::NBT::ListTagIterator> ListTagIterator(m, "ListTagIterator");
    ListTagIterator.def(
        "__next__",
        [](Amulet::NBT::ListTagIterator& self) {
            if (self.has_next()) {
                return self.next();
            }
            throw py::stop_iteration("");
        });
    ListTagIterator.def(
        "__iter__",
        [](Amulet::NBT::ListTagIterator& self) {
            return self;
        });

    ListTag.attr("__type_params__") = py::make_tuple(
        py::module::import("typing").attr("TypeVar")(
            "TagT",
            py::type::of<Amulet::NBT::ByteTag>(),
            py::type::of<Amulet::NBT::ShortTag>(),
            py::type::of<Amulet::NBT::IntTag>(),
            py::type::of<Amulet::NBT::LongTag>(),
            py::type::of<Amulet::NBT::FloatTag>(),
            py::type::of<Amulet::NBT::DoubleTag>(),
            py::type::of<Amulet::NBT::ByteArrayTag>(),
            py::type::of<Amulet::NBT::StringTag>(),
            py::type::of<Amulet::NBT::ListTag>(),
            py::type::of<Amulet::NBT::CompoundTag>(),
            py::type::of<Amulet::NBT::IntArrayTag>(),
            py::type::of<Amulet::NBT::LongArrayTag>()));
    ListTag.def_property_readonly_static("tag_id", [](py::object) { return 9; });
    ListTag.def(
        py::init([](
                     Amulet::pybind11_extensions::PyObjectCpp<
                         std::variant<
                             py::typing::Iterable<Amulet::NBT::ByteTag>,
                             py::typing::Iterable<Amulet::NBT::ShortTag>,
                             py::typing::Iterable<Amulet::NBT::IntTag>,
                             py::typing::Iterable<Amulet::NBT::LongTag>,
                             py::typing::Iterable<Amulet::NBT::FloatTag>,
                             py::typing::Iterable<Amulet::NBT::DoubleTag>,
                             py::typing::Iterable<Amulet::NBT::StringTag>,
                             py::typing::Iterable<Amulet::NBT::ListTag>,
                             py::typing::Iterable<Amulet::NBT::CompoundTag>,
                             py::typing::Iterable<Amulet::NBT::ByteArrayTag>,
                             py::typing::Iterable<Amulet::NBT::IntArrayTag>,
                             py::typing::Iterable<Amulet::NBT::LongArrayTag>>>
                         value,
                     std::uint8_t element_tag_id) {
            Amulet::NBT::ListTagPtr tag = std::make_shared<Amulet::NBT::ListTag>();
            switch (element_tag_id) {
#define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) \
    case ID:                                           \
        tag->emplace<LIST_TAG>();                      \
        break;
                FOR_EACH_LIST_TAG2(CASE)
            default:
                throw std::invalid_argument("element_tag_id must be in the range 0-12");
#undef CASE
            }
            ListTag_extend(*tag, value);
            return tag;
        }),
        py::arg("tags") = py::tuple(), py::arg("element_tag_id") = 1);
    ListTag.attr("__class_getitem__") = PyClassMethod_New(
        py::cpp_function([](const py::type& cls, const py::args& args) { return cls; }).ptr());
    auto py_getter = [](const Amulet::NBT::ListTag& self) {
        py::typing::List<TagNodeT> list;
        std::visit([&list](auto&& vec) {
            using T = std::decay_t<decltype(vec)>;
            if constexpr (!std::is_same_v<T, std::monostate>) {
                for (const auto& tag : vec) {
                    list.append(tag);
                }
            }
        },
            self);
        return list;
    };
    ListTag.def_property_readonly(
        "py_list",
        py_getter,
        py::doc(
            "A python list representation of the class.\n"
            "\n"
            "The returned list is a shallow copy of the class, meaning changes will not mirror the instance.\n"
            "Use the public API to modify the internal data.\n"));
    ListTag.def_property_readonly(
        "py_data",
        [py_getter](const Amulet::NBT::ListTag& self) -> py::object {
            return py_getter(self);
        },
        py::doc(
            "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
            "\n"
            "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
            "This is here for convenience to get a python representation under the same property name.\n"));
    SerialiseTag(ListTag);
    ListTag.def(
        "__repr__",
        [](const Amulet::NBT::ListTag& self) {
            std::string out = "amulet.nbt.ListTag([";

            std::visit([&out](auto&& vec) {
                using T = std::decay_t<decltype(vec)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    // do nothing
                } else {
                    for (size_t i = 0; i < vec.size(); i++) {
                        if (i != 0) {
                            out += ", ";
                        }
                        out += py::repr(py::cast(vec[i]));
                    }
                }
            },
                self);

            out += "], ";
            out += std::to_string(self.index());
            out += ")";
            return out;
        });
    ListTag.def(
        "__str__",
        [](const Amulet::NBT::ListTag& self) {
            return py::str(py::list(py::cast(self)));
        });
    ListTag.def(
        py::pickle(
            [](const Amulet::NBT::ListTag& self) {
                return py::bytes(Amulet::NBT::encode_nbt("", self, std::endian::big, Amulet::NBT::utf8_to_mutf8));
            },
            [](py::bytes state) {
                return std::get<Amulet::NBT::ListTagPtr>(
                    Amulet::NBT::decode_nbt(state, std::endian::big, Amulet::NBT::mutf8_to_utf8).tag_node);
            }));
    ListTag.def(
        "__copy__",
        [](const Amulet::NBT::ListTag& self) -> Self {
            return py::cast(std::make_shared<Amulet::NBT::ListTag>(self));
        });
    ListTag.def(
        "__deepcopy__",
        [](const Amulet::NBT::ListTag& self, py::dict) -> Self {
            return py::cast(std::make_shared<Amulet::NBT::ListTag>(deep_copy(self)));
        },
        py::arg("memo"));
    ListTag.def(
        "__eq__",
        [](const Amulet::NBT::ListTag& self, const Amulet::NBT::ListTag& other) {
            return Amulet::NBT::NBTTag_eq(self, other);
        },
        py::is_operator());
    ListTag.def(
        "__len__",
        [](const Amulet::NBT::ListTag& self) {
            return Amulet::NBT::ListTag_size(self);
        });
    ListTag.def(
        "__bool__",
        [](const Amulet::NBT::ListTag& self) {
            return Amulet::NBT::ListTag_size(self) != 0;
        });
    ListTag.def_property_readonly(
        "element_tag_id",
        [](const Amulet::NBT::ListTag& self) {
            return self.index();
        },
        py::doc(
            "The numerical id of the element type in this list.\n"
            "\n"
            "Will be an int in the range 0-12."));
    const std::array<py::object, 13> NBTClasses = {
        py::none(),
        m.attr("ByteTag"),
        m.attr("ShortTag"),
        m.attr("IntTag"),
        m.attr("LongTag"),
        m.attr("FloatTag"),
        m.attr("DoubleTag"),
        m.attr("ByteArrayTag"),
        m.attr("StringTag"),
        ListTag,
        m.attr("CompoundTag"),
        m.attr("IntArrayTag"),
        m.attr("LongArrayTag"),
    };
    ListTag.def_property_readonly(
        "element_class",
        [NBTClasses](const Amulet::NBT::ListTag& self) -> Amulet::pybind11_extensions::PyObjectCpp<std::variant<py::typing::Type<TagNodeT>, std::monostate>> {
            return NBTClasses[self.index()];
        },
        py::doc("The python class for the tag type contained in this list or None if the list tag is in the 0 state."));
    ListTag.def(
        "__getitem__",
        [](const Amulet::NBT::ListTag& self, Py_ssize_t item) -> TagNodeT {
            return Amulet::NBT::ListTag_get_node<Py_ssize_t>(self, item);
        },
        py::arg("item"));
    ListTag.def(
        "__getitem__",
        [](const Amulet::NBT::ListTag& self, const py::slice& slice) {
            py::typing::List<TagNodeT> out;
            Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
            if (!slice.compute(ListTag_size(self), &start, &stop, &step, &slice_length)) {
                throw py::error_already_set();
            }
            for (Py_ssize_t i = 0; i < slice_length; ++i) {
                out.append(Amulet::NBT::ListTag_get_node<Py_ssize_t>(self, start));
                start += step;
            }
            return out;
        },
        py::arg("item"));
    ListTag.def(
        "__iter__",
        [](const Amulet::NBT::ListTagPtr& self) {
            return Amulet::NBT::ListTagIterator(self, 0, 1);
        });
    ListTag.def(
        "__reversed__",
        [](const Amulet::NBT::ListTagPtr& self) {
            return Amulet::NBT::ListTagIterator(self, ListTag_size(*self) - 1, -1);
        });
    ListTag.def(
        "__contains__",
        [](const Amulet::NBT::ListTag& self, Amulet::NBT::TagNode item) {
            return std::visit([&self](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                if (std::holds_alternative<std::vector<T>>(self)) {
                    const std::vector<T>& vec = std::get<std::vector<T>>(self);
                    for (const T& tag2 : vec) {
                        if (Amulet::NBT::NBTTag_eq(tag, tag2)) {
                            return true;
                        }
                    }
                }
                return false;
            },
                item);
        },
        py::arg("item"));
    ListTag.def(
        "index",
        [](const Amulet::NBT::ListTag& self, TagNodeT node, Py_ssize_t start, Py_ssize_t stop) -> size_t {
            return std::visit([&self, &start, &stop](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                return Amulet::NBT::ListTag_index<T, Py_ssize_t>(self, tag, start, stop);
            },
                node);
        },
        py::arg("tag"), py::arg("start") = 0, py::arg("stop") = std::numeric_limits<Py_ssize_t>::max());
    ListTag.def(
        "count",
        [](const Amulet::NBT::ListTag& self, TagNodeT node) -> size_t {
            return std::visit([&self](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                return Amulet::NBT::ListTag_count<T>(self, tag);
            },
                node);
        },
        py::arg("tag"));
    ListTag.def(
        "__setitem__",
        [](Amulet::NBT::ListTag& self, Py_ssize_t index, TagNodeT node) {
            std::visit([&self, &index](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                Amulet::NBT::ListTag_set<T, Py_ssize_t>(self, index, tag);
            },
                node);
        },
        py::arg("item"), py::arg("tag"));
    ListTag.def(
        "__setitem__",
        [](Amulet::NBT::ListTag& self, const py::slice& slice, py::object values) {
            // Cast values to a list to get a consistent format
            auto list = py::list(values);
            if (list) {
                // If the value has items in it
                // Switch based on the type of the first element
                Amulet::NBT::TagNode first = list[0].cast<Amulet::NBT::TagNode>();
                std::visit([&self, &list, &slice](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    // Cast to C++ objects. Also validate that they are all the same type.
                    std::vector<T> vec;
                    vec.push_back(tag);
                    for (size_t i = 1; i < list.size(); i++) {
                        vec.push_back(list[i].cast<T>());
                    }
                    ListTag_set_slice<T>(self, slice, vec);
                },
                    first);
            } else {
                // The value is empty
                // empty the slice
                std::visit([&self, &slice](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    if constexpr (std::is_same_v<T, std::monostate>) {
                        // Do nothing
                    } else {
                        auto vec = std::vector<typename T::value_type>();
                        ListTag_set_slice<typename T::value_type>(self, slice, vec);
                    }
                },
                    self);
            }
        },
        py::arg("item"), py::arg("tags"));
    ListTag.def(
        "__delitem__",
        [](Amulet::NBT::ListTag& self, Py_ssize_t item) {
            Amulet::NBT::ListTag_del<Py_ssize_t>(self, item);
        },
        py::arg("item"));
    ListTag.def(
        "__delitem__",
        [](Amulet::NBT::ListTag& self, const py::slice& slice) {
            std::visit([&slice](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    // Do nothing
                } else {
                    ListTag_del_slice(tag, slice);
                }
            },
                self);
        },
        py::arg("item"));
    ListTag.def(
        "insert",
        [](Amulet::NBT::ListTag& self, Py_ssize_t index, TagNodeT node) {
            std::visit([&self, &index](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                Amulet::NBT::ListTag_insert<T, Py_ssize_t>(self, index, tag);
            },
                node);
        },
        py::arg("index"), py::arg("tag"));
    ListTag.def(
        "append",
        [](Amulet::NBT::ListTag& self, TagNodeT node) {
            std::visit([&self](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                Amulet::NBT::ListTag_append<T>(self, tag);
            },
                node);
        },
        py::arg("tag"));
    ListTag.def(
        "clear",
        [](Amulet::NBT::ListTag& self) {
            std::visit([](auto&& list_tag) {
                using T = std::decay_t<decltype(list_tag)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    // Do nothing
                } else {
                    list_tag.clear();
                }
            },
                self);
        });
    ListTag.def(
        "reverse",
        [](Amulet::NBT::ListTag& self) {
            std::visit([&self](auto&& list_tag) {
                using T = std::decay_t<decltype(list_tag)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    // Do nothing
                } else {
                    std::reverse(list_tag.begin(), list_tag.end());
                }
            },
                self);
        });
    ListTag.def(
        "extend",
        [](Amulet::NBT::ListTag& self, py::typing::Iterable<TagNodeT> value) {
            ListTag_extend(self, py::list(value));
        },
        py::arg("tags"));
    ListTag.def(
        "pop",
        [](Amulet::NBT::ListTag& self, Py_ssize_t item) {
            return ListTag_pop<Py_ssize_t>(self, item);
        },
        py::arg("index") = -1);
    ListTag.def(
        "remove",
        [](Amulet::NBT::ListTag& self, TagNodeT node) {
            std::visit([&self](auto&& tag) {
                using T = std::decay_t<decltype(tag)>;
                size_t index = Amulet::NBT::ListTag_index<T, Py_ssize_t>(self, tag);
                std::vector<T>& list_tag = std::get<std::vector<T>>(self);
                list_tag.erase(list_tag.begin() + index);
            },
                node);
        },
        py::arg("tag"));
    ListTag.def(
        "__iadd__",
        [](Amulet::NBT::ListTagPtr self, py::typing::Iterable<TagNodeT> value) -> Self {
            ListTag_extend(*self, py::list(value));
            return py::cast(self);
        });
    ListTag.def(
        "copy",
        [](const Amulet::NBT::ListTag& self) -> Self {
            return py::cast(std::make_shared<Amulet::NBT::ListTag>(self));
        });
#define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)                             \
    ListTag.def(                                                                   \
        "get_" TAG_NAME,                                                           \
        [](const Amulet::NBT::ListTag& self, Py_ssize_t index) {                   \
            if (!std::holds_alternative<std::vector<TAG_STORAGE>>(self)) {         \
                throw pybind11::type_error("ListTag elements are not " #TAG);      \
            }                                                                      \
            return Amulet::NBT::ListTag_get<TAG_STORAGE, Py_ssize_t>(self, index); \
        },                                                                         \
        py::arg("index"),                                                          \
        py::doc(                                                                   \
            "Get the tag at index if it is a " #TAG ".\n"                          \
            "\n"                                                                   \
            ":param index: The index to get\n"                                     \
            ":return: The " #TAG ".\n"                                             \
            ":raises: IndexError if the index is outside the list.\n"              \
            ":raises: TypeError if the stored type is not a " #TAG));
    FOR_EACH_LIST_TAG(CASE)
#undef CASE
}
