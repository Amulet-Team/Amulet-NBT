#pragma once

// All of the NBT equal functions

#include <amulet/nbt/export.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/named_tag.hpp>
#include <amulet/nbt/tag/string.hpp>

namespace Amulet {
namespace NBT {
    AMULET_NBT_EXPORT bool NBTTag_eq(const ByteTag& a, const ByteTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const ShortTag& a, const ShortTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const IntTag& a, const IntTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const LongTag& a, const LongTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const FloatTag& a, const FloatTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const DoubleTag& a, const DoubleTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const ByteArrayTag& a, const ByteArrayTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const StringTag& a, const StringTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const ListTag& a, const ListTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const CompoundTag& a, const CompoundTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const IntArrayTag& a, const IntArrayTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const LongArrayTag& a, const LongArrayTag& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const TagNode& a, const TagNode& b);
    AMULET_NBT_EXPORT bool NBTTag_eq(const NamedTag& a, const NamedTag& b);
} // namespace NBT
} // namespace Amulet
