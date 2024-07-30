#pragma once

#include <utility>
#include <string>
#include <bit>
#include <vector>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/tag/named_tag.hpp>
#include <amulet_nbt/io/binary_reader.hpp>
#include <amulet_nbt/io/binary_writer.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace AmuletNBT {
    NamedTag read_nbt(BinaryReader& reader);
    NamedTag read_nbt(const std::string&, std::endian, StringDecode, size_t& offset);
    NamedTag read_nbt(const std::string&, std::endian, StringDecode);
    std::vector<NamedTag> read_nbt_array(const std::string&, std::endian, StringDecode, size_t& offset);
    std::vector<NamedTag> read_nbt_array(const std::string&, std::endian, StringDecode, size_t& offset, size_t count);

    void write_nbt(BinaryWriter&, const std::string& name, const ByteTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const ShortTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const IntTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const LongTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const FloatTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const DoubleTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const ByteArrayTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const StringTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const ListTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const CompoundTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const IntArrayTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const LongArrayTag&);
    void write_nbt(BinaryWriter&, const std::string& name, const TagNode&);
    void write_nbt(BinaryWriter&, const NamedTag& tag);
    
    std::string write_nbt(const std::string& name, const ByteTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const ShortTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const IntTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const LongTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const FloatTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const DoubleTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const ByteArrayTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const StringTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const ListTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const CompoundTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const IntArrayTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const LongArrayTag&, std::endian, StringEncode);
    std::string write_nbt(const std::string& name, const TagNode&, std::endian, StringEncode);
    std::string write_nbt(const NamedTag& tag, std::endian, StringEncode);
}
