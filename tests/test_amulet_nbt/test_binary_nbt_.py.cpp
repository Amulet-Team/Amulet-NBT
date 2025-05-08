#include <pybind11/pybind11.h>

#include <bit>
#include <string>

#include <amulet/io/binary_writer.hpp>

#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/tag/named_tag.hpp>

namespace py = pybind11;

void init_binary_nbt(py::module m_parent)
{
    auto m = m_parent.def_submodule("test_binary_nbt_");

    m.def("encode_binary_nbt", [](const Amulet::NBT::NamedTag& named_tag) {
        Amulet::BinaryWriter writer(std::endian::big);
        Amulet::NBT::encode_nbt(writer, named_tag);
        return py::bytes(writer.get_buffer());
    });
}
