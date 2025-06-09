if (NOT TARGET amulet_nbt)
    message(STATUS "Finding amulet_nbt")

    find_package(amulet_io CONFIG REQUIRED)

    set(amulet_nbt_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/../..")
    find_library(amulet_nbt_LIBRARY NAMES amulet_nbt PATHS "${CMAKE_CURRENT_LIST_DIR}")
    message(STATUS "amulet_nbt_LIBRARY: ${amulet_nbt_LIBRARY}")

    add_library(amulet_nbt_bin SHARED IMPORTED)
    set_target_properties(amulet_nbt_bin PROPERTIES
        IMPORTED_IMPLIB "${amulet_nbt_LIBRARY}"
    )

    add_library(amulet_nbt INTERFACE)
    target_link_libraries(amulet_nbt INTERFACE amulet_io)
    target_link_libraries(amulet_nbt INTERFACE amulet_nbt_bin)
    target_include_directories(amulet_nbt INTERFACE ${amulet_nbt_INCLUDE_DIR})
endif()
