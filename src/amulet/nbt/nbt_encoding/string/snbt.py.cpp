#include <string>

#include <pybind11/operators.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <amulet/nbt/nbt_encoding/string.hpp>

namespace py = pybind11;

void init_snbt(py::module& m)
{
    m.def(
        "read_snbt",
        [](std::string snbt) {
            return Amulet::NBT::decode_snbt(snbt);
        },
        py::arg("snbt"),
        py::doc(
            "Parse Stringified NBT.\n"
            "\n"
            ":param snbt: The SNBT string to parse.\n"
            ":return: The tag\n"
            ":raises: ValueError if the SNBT format is invalid.\n"
            ":raises: IndexError if the data overflows the given string.\n"));
}
