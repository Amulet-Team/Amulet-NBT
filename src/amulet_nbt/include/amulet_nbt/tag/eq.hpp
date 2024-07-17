#pragma once

// All of the NBT equal functions

#include <amulet_nbt/tag/eq.hpp>

namespace AmuletNBT {
    bool NBTTag_eq(const AmuletNBT::ByteTag a, const AmuletNBT::ByteTag b);
    bool NBTTag_eq(const AmuletNBT::ShortTag a, const AmuletNBT::ShortTag b);
    bool NBTTag_eq(const AmuletNBT::IntTag a, const AmuletNBT::IntTag b);
    bool NBTTag_eq(const AmuletNBT::LongTag a, const AmuletNBT::LongTag b);
    bool NBTTag_eq(const AmuletNBT::FloatTag a, const AmuletNBT::FloatTag b);
    bool NBTTag_eq(const AmuletNBT::DoubleTag a, const AmuletNBT::DoubleTag b);
    bool NBTTag_eq(const AmuletNBT::ByteArrayTagPtr a, const AmuletNBT::ByteArrayTagPtr b);
    bool NBTTag_eq(const AmuletNBT::StringTag a, const AmuletNBT::StringTag b);
    bool NBTTag_eq(const AmuletNBT::ListTagPtr a, const AmuletNBT::ListTagPtr b);
    bool NBTTag_eq(const AmuletNBT::CompoundTagPtr a, const AmuletNBT::CompoundTagPtr b);
    bool NBTTag_eq(const AmuletNBT::IntArrayTagPtr a, const AmuletNBT::IntArrayTagPtr b);
    bool NBTTag_eq(const AmuletNBT::LongArrayTagPtr a, const AmuletNBT::LongArrayTagPtr b);
    bool NBTTag_eq(const AmuletNBT::TagNode a, const AmuletNBT::TagNode b);
}
