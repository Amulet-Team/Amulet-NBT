#pragma once

#ifndef AMULET_NBT_EXPORT
    #ifdef _WIN32
        #ifdef ExportAmuletNBT
            #define AMULET_NBT_EXPORT __declspec(dllexport)
        #else
            #define AMULET_NBT_EXPORT __declspec(dllimport)
        #endif
    #else
        #define AMULET_NBT_EXPORT __attribute__((visibility("default")))
    #endif
#endif
