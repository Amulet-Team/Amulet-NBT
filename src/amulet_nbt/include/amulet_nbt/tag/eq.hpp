#pragma once

// All of the NBT equal functions

#include <amulet_nbt/dll.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/named_tag.hpp>

namespace AmuletNBT {
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::ByteTag& a, const AmuletNBT::ByteTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::ShortTag& a, const AmuletNBT::ShortTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::IntTag& a, const AmuletNBT::IntTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::LongTag& a, const AmuletNBT::LongTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::FloatTag& a, const AmuletNBT::FloatTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::DoubleTag& a, const AmuletNBT::DoubleTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::ByteArrayTag& a, const AmuletNBT::ByteArrayTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::StringTag& a, const AmuletNBT::StringTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::ListTag& a, const AmuletNBT::ListTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::CompoundTag& a, const AmuletNBT::CompoundTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::IntArrayTag& a, const AmuletNBT::IntArrayTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::LongArrayTag& a, const AmuletNBT::LongArrayTag& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::TagNode& a, const AmuletNBT::TagNode& b);
    AMULET_NBT_DLLX bool NBTTag_eq(const AmuletNBT::NamedTag& a, const AmuletNBT::NamedTag& b);
}
