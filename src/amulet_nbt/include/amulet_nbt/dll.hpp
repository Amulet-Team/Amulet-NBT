#ifndef AMULET_NBT_DLLX
    #ifdef _WIN32
        #ifdef ExportAmuletNBT
            #define AMULET_NBT_DLLX __declspec(dllexport)
        #else
            #define AMULET_NBT_DLLX __declspec(dllimport)
        #endif
    #else
        #define AMULET_NBT_DLLX
    #endif
#endif
