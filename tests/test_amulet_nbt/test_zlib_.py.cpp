#include <pybind11/pybind11.h>

#include <amulet_nbt/zlib.hpp>

namespace py = pybind11;

void init_test_zlib(py::module m_parent){
    auto m = m_parent.def_submodule("test_zlib_");
    m.def("decompress_zlib_gzip", [](py::bytes src){
        std::string dst;
        {
            py::gil_scoped_release nogil;
            Amulet::NBT::decompress_zlib_gzip(src, dst);
        }
        return py::bytes(dst);
    });
    m.def("compress_zlib", [](py::bytes src){
        std::string dst;
        {
            py::gil_scoped_release nogil;
            Amulet::NBT::compress_zlib(src, dst);
        }
        return py::bytes(dst);
    });
    m.def("compress_gzip", [](py::bytes src){
        std::string dst;
        {
            py::gil_scoped_release nogil;
            Amulet::NBT::compress_gzip(src, dst);
        }
        return py::bytes(dst);
    });
}
