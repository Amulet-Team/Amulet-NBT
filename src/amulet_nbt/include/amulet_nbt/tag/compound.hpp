#pragma once

// Utility functions for the CompoundTag
#include <string>

#include <amulet_nbt/tag/nbt.hpp>

namespace AmuletNBT {
    class CompoundTagIterator {
        private:
            AmuletNBT::CompoundTagPtr tag;
            const AmuletNBT::CompoundTag::iterator begin;
            const AmuletNBT::CompoundTag::iterator end;
            AmuletNBT::CompoundTag::iterator pos;
            size_t size;
        public:
            CompoundTagIterator(AmuletNBT::CompoundTagPtr tag);
            std::string next();
            bool has_next();
            bool is_valid();
    };
}
