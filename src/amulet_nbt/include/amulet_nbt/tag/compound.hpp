#pragma once

// Utility functions for the CompoundTag
#include <string>

#include <amulet_nbt/tag/nbt.hpp>

namespace Amulet {
    class CompoundTagIterator {
        private:
            Amulet::CompoundTagPtr tag;
            const Amulet::CompoundTag::iterator begin;
            const Amulet::CompoundTag::iterator end;
            Amulet::CompoundTag::iterator pos;
            size_t size;
        public:
            CompoundTagIterator(Amulet::CompoundTagPtr tag);
            std::string next();
            bool has_next();
            bool is_valid();
    };
}
