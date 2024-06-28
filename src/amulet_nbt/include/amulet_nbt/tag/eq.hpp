// All of the NBT equal functions

#pragma once

#include <amulet_nbt/tag/eq.hpp>

namespace Amulet {
    bool NBTTag_eq(const Amulet::ByteTag a, const Amulet::ByteTag b);
    bool NBTTag_eq(const Amulet::ShortTag a, const Amulet::ShortTag b);
    bool NBTTag_eq(const Amulet::IntTag a, const Amulet::IntTag b);
    bool NBTTag_eq(const Amulet::LongTag a, const Amulet::LongTag b);
    bool NBTTag_eq(const Amulet::FloatTag a, const Amulet::FloatTag b);
    bool NBTTag_eq(const Amulet::DoubleTag a, const Amulet::DoubleTag b);
    bool NBTTag_eq(const Amulet::ByteArrayTagPtr a, const Amulet::ByteArrayTagPtr b);
    bool NBTTag_eq(const Amulet::StringTag a, const Amulet::StringTag b);
    bool NBTTag_eq(const Amulet::ListTagPtr a, const Amulet::ListTagPtr b);
    bool NBTTag_eq(const Amulet::CompoundTagPtr a, const Amulet::CompoundTagPtr b);
    bool NBTTag_eq(const Amulet::IntArrayTagPtr a, const Amulet::IntArrayTagPtr b);
    bool NBTTag_eq(const Amulet::LongArrayTagPtr a, const Amulet::LongArrayTagPtr b);
    bool NBTTag_eq(const Amulet::TagNode a, const Amulet::TagNode b);
}
