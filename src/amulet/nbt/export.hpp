#ifndef AMULET_NBT_EXPORT
    #ifdef _WIN32
        #ifdef ExportAmuletNBT
            #define AMULET_NBT_EXPORT __declspec(dllexport)
        #else
            #define AMULET_NBT_EXPORT __declspec(dllimport)
        #endif
    #else
        #define AMULET_NBT_EXPORT
    #endif
#endif

#if !defined(AMULET_NBT_EXPORT_EXCEPTION)
    #if defined(_LIBCPP_EXCEPTION)
        #define AMULET_NBT_EXPORT_EXCEPTION __attribute__((visibility("default")))
    #else
        #define AMULET_NBT_EXPORT_EXCEPTION
    #endif
#endif
