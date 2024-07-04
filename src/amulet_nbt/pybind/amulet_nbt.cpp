#include <pybind11/pybind11.h>
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


PYBIND11_MODULE(_nbt, m) {
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
}
