#pragma once

#include <pybind11/pybind11.h>

#include "string.hpp"

namespace py = pybind11;

namespace Amulet {
namespace NBT {
    // A utf-8 string that can contain invalid bytes.
    // surrogateescape is used to escape invalid bytes.
    class UTF8SurrogateEscape : public std::string {
    public:
        using std::string::string;
        using std::string::operator=;

        UTF8SurrogateEscape() = default;
        UTF8SurrogateEscape(const std::string& value)
            : std::string(value)
        {
        }

        UTF8SurrogateEscape(std::string&& value) noexcept
            : std::string(std::move(value))
        {
        }
    };
} // namespace NBT
} // namespace Amulet

namespace pybind11 {
namespace detail {

    template <>
    struct type_caster<Amulet::NBT::UTF8SurrogateEscape> {
        PYBIND11_TYPE_CASTER(Amulet::NBT::UTF8SurrogateEscape, io_name("str | bytes", "str"));

        static handle
        cast(const Amulet::NBT::UTF8SurrogateEscape& src, return_value_policy /*policy*/, handle /*parent*/)
        {
            handle s = PyUnicode_DecodeUTF8(src.data(), static_cast<Py_ssize_t>(src.size()), "surrogateescape");
            if (!s) {
                throw py::error_already_set();
            }
            return s;
        }

        bool load(handle src, bool /*convert*/)
        {
            if (!src) {
                return false;
            }

            if (PyUnicode_Check(src.ptr())) {
                auto b = reinterpret_steal<py::bytes>(
                    PyUnicode_AsEncodedString(src.ptr(), "utf-8", "surrogateescape"));
                if (!b) {
                    throw py::error_already_set();
                }
                char* buf;
                Py_ssize_t len;
                if (PyBytes_AsStringAndSize(b.ptr(), &buf, &len) != 0) {
                    throw py::error_already_set();
                }
                value = Amulet::NBT::UTF8SurrogateEscape(buf, static_cast<size_t>(len));
                return true;

            } else if (PyBytes_Check(src.ptr())) {
                char* buf;
                Py_ssize_t len;
                if (PyBytes_AsStringAndSize(src.ptr(), &buf, &len) != 0) {
                    throw py::error_already_set();
                }
                value = Amulet::NBT::UTF8SurrogateEscape(buf, static_cast<size_t>(len));
                return true;
            }
            return false;
        }
    };

} // namespace detail
} // namespace pybind11
