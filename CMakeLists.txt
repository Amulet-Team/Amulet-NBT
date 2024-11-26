cmake_minimum_required(VERSION 3.13)

project(amulet_nbt LANGUAGES CXX)
set(SRC_INSTALL_DIR "." CACHE PATH "The path to the src directory to install into.")

# Set C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set platform variables
if (WIN32)
	# set windows 7 as the minimum version
	add_definitions(-D_WIN32_WINNT=0x0601)
elseif(APPLE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15")
else()
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

# Add pybind11
find_package(pybind11 CONFIG REQUIRED)

# Add implementation
add_library(amulet_nbt SHARED)
target_compile_definitions(amulet_nbt PRIVATE ExportAmuletNBT)
target_include_directories(amulet_nbt PUBLIC "src/amulet_nbt/include")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/nbt_encoding/binary/read_binary.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/nbt_encoding/binary/write_binary.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/nbt_encoding/string/read_string.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/nbt_encoding/string/write_string.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/string_encoding/mutf8.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/string_encoding/utf8.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/tag/copy.cpp")
target_sources(amulet_nbt PRIVATE "src/amulet_nbt/cpp/tag/eq.cpp")

# Add python extension
pybind11_add_module(_amulet_nbt)
target_compile_definitions(_amulet_nbt PRIVATE PYBIND11_DETAILED_ERROR_MESSAGES)
target_link_libraries(_amulet_nbt PRIVATE amulet_nbt)
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/amulet_nbt.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/bnbt.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/encoding.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/snbt.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_abc_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_array_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_compound_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_float_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_int_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_list_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_named_tag.cpp")
target_sources(_amulet_nbt PRIVATE "src/amulet_nbt/pybind/tag/py_string_tag.cpp")

# Install
install(TARGETS amulet_nbt DESTINATION "${SRC_INSTALL_DIR}/amulet_nbt")
install(TARGETS _amulet_nbt DESTINATION "${SRC_INSTALL_DIR}/amulet_nbt")
