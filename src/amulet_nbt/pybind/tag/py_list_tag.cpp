#include <stdexcept>
#include <limits>
#include <array>
#include <variant>
#include <vector>
#include <string>
#include <algorithm>
#include <memory>
#include <cstdint>
#include <bit>
#include <fstream>

#include <pybind11/pybind11.h>
#include <pybind11/pytypes.h>
#include <pybind11/stl.h>
#include <pybind11/operators.h>

#include <amulet_nbt/tag/abc.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/list_methods.hpp>
#include <amulet_nbt/tag/eq.hpp>
#include <amulet_nbt/tag/copy.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>
#include <amulet_nbt/pybind/serialisation.hpp>
#include <amulet_nbt/pybind/encoding.hpp>

namespace py = pybind11;

namespace AmuletNBT {
    // A class to emulate python's iteration mechanic
    class ListTagIterator {
        private:
            ListTagPtr tag;
            size_t index;
            std::ptrdiff_t step;
        public:
            ListTagIterator(ListTagPtr tag, size_t start, std::ptrdiff_t step) : tag(tag), index(start), step(step) {};
            TagNode next() {
                auto node = ListTag_get_node<size_t>(*tag, index);
                index += step;
                return node;
            }
            bool has_next() {
                return index >= 0 && index < ListTag_size(*tag);
            }
    };
}

void ListTag_extend(AmuletNBT::ListTag& tag, py::object value){
    // The caller must ensure value is not tag
    auto it = py::iter(value);
    while (it != py::iterator::sentinel()){
        AmuletNBT::TagNode node = py::cast<AmuletNBT::TagNode>(*it);
        std::visit([&tag](auto&& node_tag) {
            using T = std::decay_t<decltype(node_tag)>;
            AmuletNBT::ListTag_append<T>(tag, node_tag);
        }, node);
        ++it;
    }
}

template <typename tagT>
void ListTag_set_slice(AmuletNBT::ListTag& self, const py::slice &slice, std::vector<tagT>& vec){
    if (std::holds_alternative<std::vector<tagT>>(self)){
        // Tag type matches
        std::vector<tagT>& list_tag = std::get<std::vector<tagT>>(self);
        Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
        if (!slice.compute(list_tag.size(), &start, &stop, &step, &slice_length)) {
            throw py::error_already_set();
        }
        if (vec.size() == slice_length){
            // Size matches. Overwrite.
            for (auto& tag: vec){
                list_tag[start] = tag;
                start += step;
            }
        } else if (step == 1) {
            // Erase the region and insert the new region
            list_tag.erase(
                list_tag.begin() + start,
                list_tag.begin() + stop
            );
            list_tag.insert(
                list_tag.begin() + start,
                vec.begin(),
                vec.end()
            );
        } else {
            throw std::invalid_argument(
                "attempt to assign sequence of size " +
                std::to_string(vec.size()) +
                " to extended slice of size " +
                std::to_string(slice_length)
            );
        }
    } else {
        // Tag type does not match
        size_t size = ListTag_size(self);
        Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
        if (!slice.compute(size, &start, &stop, &step, &slice_length)) {
            throw py::error_already_set();
        }
        if (size == slice_length){
            // Overwriting all values
            if (step == -1){
                // Reverse the element order
                std::reverse(vec.begin(), vec.end());
            } else if (step != 1){
                throw std::invalid_argument(
                    "When overwriting values in a ListTag the types must match or all tags must be overwritten."
                );
            }
            self.emplace<std::vector<tagT>>(vec);
        } else {
            throw py::type_error("NBT ListTag item mismatch.");
        }
    }
}

template <typename tagT>
void ListTag_del_slice(std::vector<tagT>& self, const py::slice &slice){
    Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
    if (!slice.compute(self.size(), &start, &stop, &step, &slice_length)) {
        throw py::error_already_set();
    }
    if (step == 1){
        self.erase(
            self.begin() + start,
            self.begin() + stop
        );
    } else if (step < 0) {
        for (Py_ssize_t i = 0; i < slice_length; i++){
            self.erase(self.begin() + (start + step * i));
        }
    } else if (step > 0) {
        // erase values back to front
        for (Py_ssize_t i = 0; i < slice_length; i++){
            self.erase(self.begin() + (start + step * (slice_length - 1 - i)));
        }
    } else {
        throw std::invalid_argument("slice step cannot be zero");
    }
}


void init_list(py::module& m) {
    py::class_<AmuletNBT::ListTagIterator, std::shared_ptr<AmuletNBT::ListTagIterator>> ListTagIterator(m, "ListTagIterator");
        ListTagIterator.def(
            "__next__",
            [](AmuletNBT::ListTagIterator& self){
                if (self.has_next()){
                    return self.next();
                }
                throw py::stop_iteration("");
            }
        );
        ListTagIterator.def(
            "__iter__",
            [](AmuletNBT::ListTagIterator& self){
                return self;
            }
        );

    py::object mutf8_encoding = m.attr("mutf8_encoding");
    py::object java_encoding = m.attr("java_encoding");
    py::object compress = py::module::import("gzip").attr("compress");
    py::object AbstractBaseMutableTag = m.attr("AbstractBaseMutableTag");

    //py::class_<AmuletNBT::ListTag, AmuletNBT::AbstractBaseMutableTag, std::shared_ptr<AmuletNBT::ListTag>> ListTag(m, "ListTag",
    py::class_<AmuletNBT::ListTag, std::shared_ptr<AmuletNBT::ListTag>> ListTag(m, "ListTag", AbstractBaseMutableTag,
    //py::class_<AmuletNBT::ListTag, std::shared_ptr<AmuletNBT::ListTag>> ListTag(m, "ListTag",
        "A Python wrapper around a C++ vector.\n"
        "\n"
        "All contained data must be of the same NBT data type."
    );
        ListTag.def_property_readonly_static("tag_id", [](py::object) {return 9;});
        ListTag.def(
            py::init([](py::object value, std::uint8_t element_tag_id) {
                AmuletNBT::ListTagPtr tag = std::make_shared<AmuletNBT::ListTag>();
                switch(element_tag_id){
                    #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG) case ID: tag->emplace<LIST_TAG>(); break;
                    FOR_EACH_LIST_TAG2(CASE)
                    default:
                        throw std::invalid_argument("element_tag_id must be in the range 0-12");
                    #undef CASE
                }
                ListTag_extend(*tag, value);
                return tag;
            }),
            py::arg("value") = py::tuple(), py::arg("element_tag_id") = 1,
            py::doc("__init__(self: amulet_nbt.ListTag, value: typing.Iterable[amulet_nbt.ByteTag] | typing.Iterable[amulet_nbt.ShortTag] | typing.Iterable[amulet_nbt.IntTag] | typing.Iterable[amulet_nbt.LongTag] | typing.Iterable[amulet_nbt.FloatTag] | typing.Iterable[amulet_nbt.DoubleTag] | typing.Iterable[amulet_nbt.ByteArrayTag] | typing.Iterable[amulet_nbt.StringTag] | typing.Iterable[amulet_nbt.ListTag] | typing.Iterable[amulet_nbt.CompoundTag] | typing.Iterable[amulet_nbt.IntArrayTag] | typing.Iterable[amulet_nbt.LongArrayTag] = (), element_tag_id = 1) -> None")
        );
        ListTag.attr("__class_getitem__") = PyClassMethod_New(
            py::cpp_function([](const py::type &cls, const py::args &args){return cls;}).ptr()
        );
        auto py_getter = [](const AmuletNBT::ListTag& self){
            py::list list;
            std::visit([&list](auto&& vec) {
                using T = std::decay_t<decltype(vec)>;
                if constexpr (std::is_same_v<T, std::monostate>) {
                    // do nothing
                }
                else {
                    for (const auto& tag : vec) {
                        list.append(tag);
                    }
                }
            }, self);
            return list;
        };
        ListTag.def_property_readonly(
            "py_list",
            py_getter,
            py::doc(
                "A python list representation of the class.\n"
                "\n"
                "The returned list is a shallow copy of the class, meaning changes will not mirror the instance.\n"
                "Use the public API to modify the internal data.\n"
            )
        );
        ListTag.def_property_readonly(
            "py_data",
            py_getter,
            py::doc(
                "A python representation of the class. Note that the return type is undefined and may change in the future.\n"
                "\n"
                "You would be better off using the py_{type} or np_array properties if you require a fixed type.\n"
                "This is here for convenience to get a python representation under the same property name.\n"
            )
        );
        SerialiseTag(ListTag)\
        ListTag.def(
            "__repr__",
            [](const AmuletNBT::ListTag& self){
                std::string out;
                out += "ListTag([";

                std::visit([&out](auto&& vec) {
                    using T = std::decay_t<decltype(vec)>;
                    if constexpr (std::is_same_v<T, std::monostate>) {
                        // do nothing
                    }
                    else {
                        for (size_t i = 0; i < vec.size(); i++){
                            if (i != 0){out += ", ";}
                            out += py::repr(py::cast(vec[i]));
                        }
                    }
                }, self);

                out += "], ";
                out += std::to_string(self.index());
                out += ")";
                return out;
            }
        );
        ListTag.def(
            "__str__",
            [](const AmuletNBT::ListTag& self){
                return py::str(py::list(py::cast(self)));
            }
        );
        ListTag.def(
            py::pickle(
                [](const AmuletNBT::ListTag& self){
                    return py::bytes(AmuletNBT::write_nbt("", self, std::endian::big, AmuletNBT::utf8_to_mutf8));
                },
                [](py::bytes state){
                    return std::get<AmuletNBT::ListTagPtr>(
                        AmuletNBT::read_nbt(state, std::endian::big, AmuletNBT::mutf8_to_utf8).tag_node
                    );
                }
            )
        );
        ListTag.def(
            "__copy__",
            [](const AmuletNBT::ListTag& self){
                return NBTTag_copy<AmuletNBT::ListTag>(self);
            }
        );
        ListTag.def(
            "__deepcopy__",
            [](const AmuletNBT::ListTag& self, py::dict){
                return AmuletNBT::NBTTag_deep_copy_list(self);
            },
            py::arg("memo")
        );
        ListTag.def(
            "__eq__",
            [](const AmuletNBT::ListTag& self, const AmuletNBT::ListTag& other){
                return AmuletNBT::NBTTag_eq(self, other);
            },
            py::is_operator()
        );
        ListTag.def(
            "__len__",
            [](const AmuletNBT::ListTag& self){
                return AmuletNBT::ListTag_size(self);
            }
        );
        ListTag.def(
            "__bool__",
            [](const AmuletNBT::ListTag& self){
                return AmuletNBT::ListTag_size(self) != 0;
            }
        );
        ListTag.def_property_readonly(
            "element_tag_id",
            [](const AmuletNBT::ListTag& self){
                return self.index();
            }
        );
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
            [&NBTClasses](const AmuletNBT::ListTag& self){
                return NBTClasses[self.index()];
            }
        );
        ListTag.def(
            "__getitem__",
            [](const AmuletNBT::ListTag& self, Py_ssize_t item){
                return AmuletNBT::ListTag_get_node<Py_ssize_t>(self, item);
            }
        );
        ListTag.def(
            "__getitem__",
            [](const AmuletNBT::ListTag& self, const py::slice& slice) {
                py::list out;
                Py_ssize_t start = 0, stop = 0, step = 0, slice_length = 0;
                if (!slice.compute(ListTag_size(self), &start, &stop, &step, &slice_length)) {
                    throw py::error_already_set();
                }
                for (Py_ssize_t i = 0; i < slice_length; ++i) {
                    out.append(AmuletNBT::ListTag_get_node<Py_ssize_t>(self, start));
                    start += step;
                }
                return out;
            });
        ListTag.def(
            "__iter__",
            [](const AmuletNBT::ListTagPtr& self) {
                return AmuletNBT::ListTagIterator(self, 0, 1);
            }
        );
        ListTag.def(
            "__reversed__",
            [](const AmuletNBT::ListTagPtr& self) {
                return AmuletNBT::ListTagIterator(self, ListTag_size(*self) - 1, -1);
            }
        );
        ListTag.def(
            "__contains__",
            [](const AmuletNBT::ListTag& self, AmuletNBT::TagNode item){
                return std::visit([&self](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    if (std::holds_alternative<std::vector<T>>(self)) {
                        const std::vector<T>& vec = std::get<std::vector<T>>(self);
                        for (const T& tag2: vec) {
                            if (AmuletNBT::NBTTag_eq(tag, tag2)) {
                                return true;
                            }
                        }
                    }
                    return false;
                }, item);
            }
        );
        ListTag.def(
            "index",
            [](const AmuletNBT::ListTag& self, AmuletNBT::TagNode node, Py_ssize_t start, Py_ssize_t stop) -> size_t {
                return std::visit([&self, &start, &stop](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    return AmuletNBT::ListTag_index<T, Py_ssize_t>(self, tag, start, stop);
                }, node);
            },
            py::arg("tag"), py::arg("start") = 0, py::arg("stop") = std::numeric_limits<Py_ssize_t>::max()
        );
        ListTag.def(
            "count",
            [](const AmuletNBT::ListTag& self, AmuletNBT::TagNode node) -> size_t {
                return std::visit([&self](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    return AmuletNBT::ListTag_count<T>(self, tag);
                }, node);
            }
        );
        ListTag.def(
            "__setitem__",
            [](AmuletNBT::ListTag& self, Py_ssize_t index, AmuletNBT::TagNode node){
                std::visit([&self, &index](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    AmuletNBT::ListTag_set<T, Py_ssize_t>(self, index, tag);
                }, node);
            }
        );
        ListTag.def(
            "__setitem__",
            [](AmuletNBT::ListTag& self, const py::slice &slice, py::object values){
                // Cast values to a list to get a consistent format
                auto list = py::list(values);
                if (list){
                    // If the value has items in it
                    // Switch based on the type of the first element
                    AmuletNBT::TagNode first = list[0].cast<AmuletNBT::TagNode>();
                    std::visit([&self, &list, &slice](auto&& tag) {
                        using T = std::decay_t<decltype(tag)>;
                        // Cast to C++ objects. Also validate that they are all the same type.
                        std::vector<T> vec;
                        vec.push_back(tag);
                        for (size_t i = 1; i < list.size(); i++){
                            vec.push_back(list[i].cast<T>());
                        }
                        ListTag_set_slice<T>(self, slice, vec);
                    }, first);
                } else {
                    // The value is empty
                    // empty the slice
                    std::visit([&self, &slice](auto&& tag) {
                        using T = std::decay_t<decltype(tag)>;
                        if constexpr (std::is_same_v<T, std::monostate>) {
                            // Do nothing
                        }
                        else {
                            auto vec = std::vector<typename T::value_type>();
                            ListTag_set_slice<typename T::value_type>(self, slice, vec);
                        }
                    }, self);
                }
            }
        );
        ListTag.def(
            "__delitem__",
            [](AmuletNBT::ListTag& self, Py_ssize_t item){
                AmuletNBT::ListTag_del<Py_ssize_t>(self, item);
            }
        );
        ListTag.def(
            "__delitem__",
            [](AmuletNBT::ListTag& self, const py::slice &slice){
                std::visit([&slice](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    if constexpr (std::is_same_v<T, std::monostate>) {
                        // Do nothing
                    }
                    else {
                        ListTag_del_slice(tag, slice);
                    }
                }, self);
            }
        );
        ListTag.def(
            "insert",
            [](AmuletNBT::ListTag& self, Py_ssize_t index, AmuletNBT::TagNode node){
                std::visit([&self, &index](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    AmuletNBT::ListTag_insert<T, Py_ssize_t>(self, index, tag);
                }, node);
            }
        );
        ListTag.def(
            "append",
            [](AmuletNBT::ListTag& self, AmuletNBT::TagNode node){
                std::visit([&self](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    AmuletNBT::ListTag_append<T>(self, tag);
                }, node);
            }
        );
        ListTag.def(
            "clear",
            [](AmuletNBT::ListTag& self){
                std::visit([](auto&& list_tag) {
                    using T = std::decay_t<decltype(list_tag)>;
                    if constexpr (std::is_same_v<T, std::monostate>) {
                        // Do nothing
                    }
                    else {
                        list_tag.clear();
                    }
                }, self);
            }
        );
        ListTag.def(
            "reverse",
            [](AmuletNBT::ListTag& self){
                std::visit([&self](auto&& list_tag) {
                    using T = std::decay_t<decltype(list_tag)>;
                    if constexpr (std::is_same_v<T, std::monostate>) {
                        // Do nothing
                    }
                    else {
                        std::reverse(list_tag.begin(), list_tag.end());
                    }
                }, self);
            }
        );
        ListTag.def(
            "extend",
            [](AmuletNBT::ListTag& self, py::object value){
                ListTag_extend(self, py::list(value));
            }
        );
        ListTag.def(
            "pop",
            [](AmuletNBT::ListTag& self, Py_ssize_t item){
                return ListTag_pop<Py_ssize_t>(self, item);
            },
            py::arg("item") = -1
        );
        ListTag.def(
            "remove",
            [](AmuletNBT::ListTag& self, AmuletNBT::TagNode node){
                std::visit([&self](auto&& tag) {
                    using T = std::decay_t<decltype(tag)>;
                    size_t index = AmuletNBT::ListTag_index<T, Py_ssize_t>(self, tag);
                    std::vector<T>& list_tag = std::get<std::vector<T>>(self);
                    list_tag.erase(list_tag.begin() + index);
                }, node);
            }
        );
        ListTag.def(
            "__iadd__",
            [](AmuletNBT::ListTagPtr self, py::object value){
                ListTag_extend(*self, py::list(value));
                return self;
            }
        );
        ListTag.def(
            "copy",
            [](const AmuletNBT::ListTag& self){
                return std::make_shared<AmuletNBT::ListTag>(self);
            }
        );
        #define CASE(ID, TAG_NAME, TAG, TAG_STORAGE, LIST_TAG)\
        ListTag.def(\
            "get_" TAG_NAME,\
            [](const AmuletNBT::ListTag& self, Py_ssize_t index){\
                if (!std::holds_alternative<std::vector<TAG_STORAGE>>(self)){\
                    throw pybind11::type_error("ListTag elements are not "#TAG);\
                }\
                return AmuletNBT::ListTag_get<TAG_STORAGE, Py_ssize_t>(self, index);\
            },\
            py::doc(\
                "Get the tag at index if it is a "#TAG".\n"\
                "\n"\
                ":param index: The index to get\n"\
                ":return: The "#TAG".\n"\
                ":raises: IndexError if the index is outside the list.\n"\
                ":raises: TypeError if the stored type is not a "#TAG\
            )\
        );
        FOR_EACH_LIST_TAG(CASE)
        #undef CASE
}
