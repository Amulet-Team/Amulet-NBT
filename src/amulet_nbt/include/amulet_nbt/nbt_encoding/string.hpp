#include <string>

#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/string_encoding.hpp>

namespace Amulet {
    void write_snbt(std::string&, const Amulet::TagNode&);
    void write_snbt(std::string&, const Amulet::ByteTag&);
    void write_snbt(std::string&, const Amulet::ShortTag&);
    void write_snbt(std::string&, const Amulet::IntTag&);
    void write_snbt(std::string&, const Amulet::LongTag&);
    void write_snbt(std::string&, const Amulet::FloatTag&);
    void write_snbt(std::string&, const Amulet::DoubleTag&);
    void write_snbt(std::string&, const Amulet::ByteArrayTag&);
    void write_snbt(std::string&, const Amulet::StringTag&);
    void write_snbt(std::string&, const Amulet::ListTag&);
    void write_snbt(std::string&, const Amulet::CompoundTag&);
    void write_snbt(std::string&, const Amulet::IntArrayTag&);
    void write_snbt(std::string&, const Amulet::LongArrayTag&);

    std::string write_snbt(const Amulet::TagNode&);
    std::string write_snbt(const Amulet::ByteTag&);
    std::string write_snbt(const Amulet::ShortTag&);
    std::string write_snbt(const Amulet::IntTag&);
    std::string write_snbt(const Amulet::LongTag&);
    std::string write_snbt(const Amulet::FloatTag&);
    std::string write_snbt(const Amulet::DoubleTag&);
    std::string write_snbt(const Amulet::ByteArrayTag&);
    std::string write_snbt(const Amulet::StringTag&);
    std::string write_snbt(const Amulet::ListTag&);
    std::string write_snbt(const Amulet::CompoundTag&);
    std::string write_snbt(const Amulet::IntArrayTag&);
    std::string write_snbt(const Amulet::LongArrayTag&);

    // Multi-line variants
    void write_formatted_snbt(std::string&, const Amulet::TagNode&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::ByteTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::ShortTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::IntTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::LongTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::FloatTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::DoubleTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::ByteArrayTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::StringTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::ListTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::CompoundTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::IntArrayTag&, const std::string& indent);
    void write_formatted_snbt(std::string&, const Amulet::LongArrayTag&, const std::string& indent);

    std::string write_formatted_snbt(const Amulet::TagNode&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::ByteTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::ShortTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::IntTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::LongTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::FloatTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::DoubleTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::ByteArrayTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::StringTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::ListTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::CompoundTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::IntArrayTag&, const std::string& indent);
    std::string write_formatted_snbt(const Amulet::LongArrayTag&, const std::string& indent);

    Amulet::TagNode read_snbt(const Amulet::CodePointVector& snbt);
    Amulet::TagNode read_snbt(const std::string& snbt);
}
