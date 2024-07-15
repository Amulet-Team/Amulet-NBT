#include <exception>

#include <pybind11/pybind11.h>

#include <amulet_nbt/common.hpp>

namespace py = pybind11;

void init_encoding(py::module&);

void init_abc(py::module&);
void init_int(py::module&);
void init_float(py::module&);
void init_string(py::module&);
void init_array(py::module&);
void init_list(py::module&);
void init_compound(py::module&);

void init_named_tag(py::module&);

void init_bnbt(py::module& m);
void init_snbt(py::module& m);


PYBIND11_MODULE(_nbt, m) {
    // Convert cast_error to type_error
    py::register_local_exception_translator([](std::exception_ptr p) {
        try {
            if (p) {
                std::rethrow_exception(p);
            }
        } catch (const py::cast_error& e) {
            py::set_error(PyExc_TypeError, e.what());
        }
    });

    py::register_exception_translator([](std::exception_ptr p) {
        try {
            if (p) {
                std::rethrow_exception(p);
            }
        } catch (const AmuletNBT::type_error& e) {
            py::set_error(PyExc_TypeError, e.what());
        }
    });

    init_encoding(m);
    init_abc(m);
    init_int(m);
    init_float(m);
    init_string(m);
    init_array(m);
    init_compound(m);
    init_list(m);

    init_named_tag(m);

    init_bnbt(m);
    init_snbt(m);
}
