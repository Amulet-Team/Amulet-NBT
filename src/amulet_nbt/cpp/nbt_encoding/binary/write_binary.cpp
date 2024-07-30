#include <string>
#include <bit>
#include <variant>
#include <stdexcept>
#include <type_traits>
#include <limits>
#include <cstdint>
#include <memory>
#include <vector>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/int.hpp>
#include <amulet_nbt/tag/float.hpp>
#include <amulet_nbt/tag/string.hpp>
#include <amulet_nbt/tag/list.hpp>
#include <amulet_nbt/tag/compound.hpp>
#include <amulet_nbt/tag/array.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>

#include <amulet_nbt/io/binary_writer.hpp>


template <
    class T,
    std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteTag> ||
        std::is_same_v<T, AmuletNBT::ShortTag> ||
        std::is_same_v<T, AmuletNBT::IntTag> ||
        std::is_same_v<T, AmuletNBT::LongTag> ||
        std::is_same_v<T, AmuletNBT::FloatTag> ||
        std::is_same_v<T, AmuletNBT::DoubleTag>,
        bool
    > = true>
inline void write_payload(AmuletNBT::BinaryWriter& writer, const T& value){
    writer.writeNumeric<typename T::native_type>(value);
};

inline void write_string(AmuletNBT::BinaryWriter& writer, const std::string& value){
    std::string encoded_string = writer.encodeString(value);
    if (encoded_string.size() > static_cast<size_t>(std::numeric_limits<std::uint16_t>::max())){
        throw std::overflow_error("String of length " + std::to_string(encoded_string.size()) + " is too long.");
    }
    writer.writeNumeric<std::uint16_t>(static_cast<std::uint16_t>(encoded_string.size()));
    writer.writeBytes(encoded_string);
}

template <
    typename T,
    std::enable_if_t<
    std::is_same_v<T, AmuletNBT::StringTag>,
    bool
> = true>
inline void write_payload(AmuletNBT::BinaryWriter& writer, const T& value) {
    write_string(writer, value);
};

template <
    class T,
    std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteArrayTag> ||
        std::is_same_v<T, AmuletNBT::IntArrayTag> ||
        std::is_same_v<T, AmuletNBT::LongArrayTag>,
        bool
    > = true
>
inline void write_payload(AmuletNBT::BinaryWriter& writer, const T& value){
    if (value.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("Array of length " + std::to_string(value.size()) + " is too long.");
    }
    std::int32_t length = static_cast<std::int32_t>(value.size());
    writer.writeNumeric<std::int32_t>(length);
    for (const typename T::value_type& element: value){
        writer.writeNumeric<typename T::value_type>(element);
    }
}


template <
    class T,
    std::enable_if_t<std::is_same_v<T, AmuletNBT::ListTag>, bool> = true
>
inline void write_payload(AmuletNBT::BinaryWriter& writer, const T& value);

template <
    class T,
    std::enable_if_t<std::is_same_v<T, AmuletNBT::CompoundTag>, bool> = true
>
inline void write_payload(AmuletNBT::BinaryWriter& writer, const T& value);


template <
    class T,
    std::enable_if_t<
    std::is_same_v<T, AmuletNBT::ListTagPtr> ||
    std::is_same_v<T, AmuletNBT::CompoundTagPtr> ||
    std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
    std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
    std::is_same_v<T, AmuletNBT::LongArrayTagPtr>,
    bool
    > = true
>
inline void write_payload(AmuletNBT::BinaryWriter & writer, const T value) {
    write_payload(writer, *value);
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteTag> ||
        std::is_same_v<T, AmuletNBT::ShortTag> ||
        std::is_same_v<T, AmuletNBT::IntTag> ||
        std::is_same_v<T, AmuletNBT::LongTag> ||
        std::is_same_v<T, AmuletNBT::FloatTag> ||
        std::is_same_v<T, AmuletNBT::DoubleTag> ||
        std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::StringTag> ||
        std::is_same_v<T, AmuletNBT::ListTagPtr> ||
        std::is_same_v<T, AmuletNBT::CompoundTagPtr> ||
        std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
        std::is_same_v<T, AmuletNBT::LongArrayTagPtr>,
        bool
    > = true
>
inline void write_list_tag_payload(AmuletNBT::BinaryWriter& writer, const std::vector<T>& list){
    if (list.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())){
        throw std::overflow_error("List of length " + std::to_string(list.size()) + " is too long.");
    }
    writer.writeNumeric<std::uint8_t>(AmuletNBT::tag_id_v<T>);
    writer.writeNumeric<std::int32_t>(static_cast<std::int32_t>(list.size()));
    for (const T& element: list){
        write_payload(writer, element);
    }
}


template <>
inline void write_payload<AmuletNBT::ListTag>(AmuletNBT::BinaryWriter& writer, const AmuletNBT::ListTag& value){
    std::visit([&writer](auto&& tag) {
        using T = std::decay_t<decltype(tag)>;
        if constexpr (std::is_same_v<T, std::monostate>) {
            writer.writeNumeric<std::uint8_t>(0);
            writer.writeNumeric<std::int32_t>(0);
        }
        else {
            write_list_tag_payload(writer, tag);
        }
    }, value);
}


template <
    typename T,
    std::enable_if_t<
        std::is_same_v<T, AmuletNBT::ByteTag> ||
        std::is_same_v<T, AmuletNBT::ShortTag> ||
        std::is_same_v<T, AmuletNBT::IntTag> ||
        std::is_same_v<T, AmuletNBT::LongTag> ||
        std::is_same_v<T, AmuletNBT::FloatTag> ||
        std::is_same_v<T, AmuletNBT::DoubleTag> ||
        std::is_same_v<T, AmuletNBT::ByteArrayTag> ||
        std::is_same_v<T, AmuletNBT::StringTag> ||
        std::is_same_v<T, AmuletNBT::ListTag> ||
        std::is_same_v<T, AmuletNBT::CompoundTag> ||
        std::is_same_v<T, AmuletNBT::IntArrayTag> ||
        std::is_same_v<T, AmuletNBT::LongArrayTag>,
        bool
    > = true
>
inline void write_name_and_tag(AmuletNBT::BinaryWriter& writer, const std::string& name, const T& tag){
    writer.writeNumeric<std::uint8_t>(AmuletNBT::tag_id_v<T>);
    write_string(writer, name);
    write_payload(writer, tag);
}

template <
    typename T,
    std::enable_if_t<
    std::is_same_v<T, AmuletNBT::ByteArrayTagPtr> ||
    std::is_same_v<T, AmuletNBT::ListTagPtr> ||
    std::is_same_v<T, AmuletNBT::CompoundTagPtr> ||
    std::is_same_v<T, AmuletNBT::IntArrayTagPtr> ||
    std::is_same_v<T, AmuletNBT::LongArrayTagPtr>,
    bool
    > = true
>
inline void write_name_and_tag(AmuletNBT::BinaryWriter & writer, const std::string & name, const T tag) {
    write_name_and_tag<typename T::element_type>(writer, name, *tag);
}


template <
    typename T,
    std::enable_if_t<std::is_same_v<T, AmuletNBT::TagNode>, bool> = true
>
inline void write_name_and_tag(AmuletNBT::BinaryWriter& writer, const std::string& name, const AmuletNBT::TagNode& node){
    std::visit([&writer, &name](auto&& tag) {
        using tagT = std::decay_t<decltype(tag)>;
        write_name_and_tag<tagT>(writer, name, tag);
    }, node);
}


template <>
inline void write_payload<AmuletNBT::CompoundTag>(AmuletNBT::BinaryWriter& writer, const AmuletNBT::CompoundTag& value){
    for (auto it = value.begin(); it != value.end(); it++){
        write_name_and_tag<AmuletNBT::TagNode>(writer, it->first, it->second);
    }
    writer.writeNumeric<std::uint8_t>(0);
};


template <typename T>
inline std::string _write_nbt(const std::string& name, const T& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
    AmuletNBT::BinaryWriter writer(endianness, string_encode);
    write_name_and_tag<T>(writer, name, tag);
    return writer.getBuffer();
}

namespace AmuletNBT {
    void write_nbt(BinaryWriter& writer, const std::string& name, const ByteTag& tag) {
        write_name_and_tag<ByteTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const ShortTag& tag) {
        write_name_and_tag<ShortTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const IntTag& tag) {
        write_name_and_tag<IntTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const LongTag& tag) {
        write_name_and_tag<LongTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const FloatTag& tag) {
        write_name_and_tag<FloatTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const DoubleTag& tag) {
        write_name_and_tag<DoubleTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const ByteArrayTag& tag) {
        write_name_and_tag<ByteArrayTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const StringTag& tag) {
        write_name_and_tag<StringTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const ListTag& tag) {
        write_name_and_tag<ListTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const CompoundTag& tag) {
        write_name_and_tag<CompoundTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const IntArrayTag& tag) {
        write_name_and_tag<IntArrayTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const LongArrayTag& tag) {
        write_name_and_tag<LongArrayTag>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const std::string& name, const TagNode& tag) {
        write_name_and_tag<TagNode>(writer, name, tag);
    }
    void write_nbt(BinaryWriter& writer, const NamedTag& tag) {
        write_name_and_tag<TagNode>(writer, tag.name, tag.tag_node);
    }

    std::string write_nbt(const std::string& name, const AmuletNBT::ByteTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::ShortTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::IntTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::LongTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::FloatTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::DoubleTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::ByteArrayTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::StringTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::ListTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::CompoundTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::IntArrayTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::LongArrayTag& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const std::string& name, const AmuletNBT::TagNode& tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return _write_nbt(name, tag, endianness, string_encode);
    };
    std::string write_nbt(const AmuletNBT::NamedTag& named_tag, std::endian endianness, AmuletNBT::StringEncode string_encode){
        return write_nbt(named_tag.name, named_tag.tag_node, endianness, string_encode);
    }
}
