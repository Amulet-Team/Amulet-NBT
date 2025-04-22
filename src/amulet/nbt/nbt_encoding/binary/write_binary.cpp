#include <bit>
#include <cstdint>
#include <limits>
#include <memory>
#include <optional>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <variant>
#include <vector>

#include <amulet/nbt/common.hpp>
#include <amulet/nbt/export.hpp>
#include <amulet/nbt/nbt_encoding/binary.hpp>
#include <amulet/nbt/tag/array.hpp>
#include <amulet/nbt/tag/compound.hpp>
#include <amulet/nbt/tag/float.hpp>
#include <amulet/nbt/tag/int.hpp>
#include <amulet/nbt/tag/list.hpp>
#include <amulet/nbt/tag/string.hpp>

#include <amulet/io/binary_writer.hpp>

namespace Amulet {
namespace NBT {

    template <
        class T,
        std::enable_if_t<
            std::is_same_v<T, ByteTag> || std::is_same_v<T, ShortTag> || std::is_same_v<T, IntTag> || std::is_same_v<T, LongTag> || std::is_same_v<T, FloatTag> || std::is_same_v<T, DoubleTag>,
            bool>
        = true>
    inline void write_payload(BinaryWriter& writer, const T& value)
    {
        writer.write_numeric<typename T::native_type>(value);
    };

    inline void write_string(BinaryWriter& writer, const std::string& value)
    {
        std::string encoded_string = writer.encode_string(value);
        if (encoded_string.size() > static_cast<size_t>(std::numeric_limits<std::uint16_t>::max())) {
            throw std::overflow_error("String of length " + std::to_string(encoded_string.size()) + " is too long.");
        }
        writer.write_numeric<std::uint16_t>(static_cast<std::uint16_t>(encoded_string.size()));
        writer.write_bytes(encoded_string);
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, StringTag>,
            bool>
        = true>
    inline void write_payload(BinaryWriter& writer, const T& value)
    {
        write_string(writer, value);
    };

    template <
        class T,
        std::enable_if_t<
            std::is_same_v<T, ByteArrayTag> || std::is_same_v<T, IntArrayTag> || std::is_same_v<T, LongArrayTag>,
            bool>
        = true>
    inline void write_payload(BinaryWriter& writer, const T& value)
    {
        if (value.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())) {
            throw std::overflow_error("Array of length " + std::to_string(value.size()) + " is too long.");
        }
        std::int32_t length = static_cast<std::int32_t>(value.size());
        writer.write_numeric<std::int32_t>(length);
        for (const typename T::value_type& element : value) {
            writer.write_numeric<typename T::value_type>(element);
        }
    }

    template <
        class T,
        std::enable_if_t<std::is_same_v<T, ListTag>, bool> = true>
    inline void write_payload(BinaryWriter& writer, const T& value);

    template <
        class T,
        std::enable_if_t<std::is_same_v<T, CompoundTag>, bool> = true>
    inline void write_payload(BinaryWriter& writer, const T& value);

    template <
        class T,
        std::enable_if_t<
            std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr> || std::is_same_v<T, ByteArrayTagPtr> || std::is_same_v<T, IntArrayTagPtr> || std::is_same_v<T, LongArrayTagPtr>,
            bool>
        = true>
    inline void write_payload(BinaryWriter& writer, const T value)
    {
        write_payload(writer, *value);
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, ByteTag> || std::is_same_v<T, ShortTag> || std::is_same_v<T, IntTag> || std::is_same_v<T, LongTag> || std::is_same_v<T, FloatTag> || std::is_same_v<T, DoubleTag> || std::is_same_v<T, ByteArrayTagPtr> || std::is_same_v<T, StringTag> || std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr> || std::is_same_v<T, IntArrayTagPtr> || std::is_same_v<T, LongArrayTagPtr>,
            bool>
        = true>
    inline void write_list_tag_payload(BinaryWriter& writer, const std::vector<T>& list)
    {
        if (list.size() > static_cast<size_t>(std::numeric_limits<std::int32_t>::max())) {
            throw std::overflow_error("List of length " + std::to_string(list.size()) + " is too long.");
        }
        writer.write_numeric<std::uint8_t>(tag_id_v<T>);
        writer.write_numeric<std::int32_t>(static_cast<std::int32_t>(list.size()));
        for (const T& element : list) {
            write_payload(writer, element);
        }
    }

    template <>
    inline void write_payload<ListTag>(BinaryWriter& writer, const ListTag& value)
    {
        std::visit([&writer](auto&& tag) {
            using T = std::decay_t<decltype(tag)>;
            if constexpr (std::is_same_v<T, std::monostate>) {
                writer.write_numeric<std::uint8_t>(0);
                writer.write_numeric<std::int32_t>(0);
            } else {
                write_list_tag_payload(writer, tag);
            }
        },
            value);
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, ByteTag> || std::is_same_v<T, ShortTag> || std::is_same_v<T, IntTag> || std::is_same_v<T, LongTag> || std::is_same_v<T, FloatTag> || std::is_same_v<T, DoubleTag> || std::is_same_v<T, ByteArrayTag> || std::is_same_v<T, StringTag> || std::is_same_v<T, ListTag> || std::is_same_v<T, CompoundTag> || std::is_same_v<T, IntArrayTag> || std::is_same_v<T, LongArrayTag>,
            bool>
        = true>
    inline void write_name_and_tag(BinaryWriter& writer, const std::optional<std::string>& name, const T& tag)
    {
        writer.write_numeric<std::uint8_t>(tag_id_v<T>);
        if (name)
            write_string(writer, *name);
        write_payload(writer, tag);
    }

    template <
        typename T,
        std::enable_if_t<
            std::is_same_v<T, ByteArrayTagPtr> || std::is_same_v<T, ListTagPtr> || std::is_same_v<T, CompoundTagPtr> || std::is_same_v<T, IntArrayTagPtr> || std::is_same_v<T, LongArrayTagPtr>,
            bool>
        = true>
    inline void write_name_and_tag(BinaryWriter& writer, const std::optional<std::string>& name, const T tag)
    {
        write_name_and_tag<typename T::element_type>(writer, name, *tag);
    }

    template <
        typename T,
        std::enable_if_t<std::is_same_v<T, TagNode>, bool> = true>
    inline void write_name_and_tag(BinaryWriter& writer, const std::optional<std::string>& name, const TagNode& node)
    {
        std::visit([&writer, &name](auto&& tag) {
            using tagT = std::decay_t<decltype(tag)>;
            write_name_and_tag<tagT>(writer, name, tag);
        },
            node);
    }

    template <>
    inline void write_payload<CompoundTag>(BinaryWriter& writer, const CompoundTag& value)
    {
        for (auto it = value.begin(); it != value.end(); it++) {
            write_name_and_tag<TagNode>(writer, it->first, it->second);
        }
        writer.write_numeric<std::uint8_t>(0);
    };

    template <typename T>
    inline std::string _encode_nbt(const std::optional<std::string>& name, const T& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        BinaryWriter writer(endianness, string_encode);
        write_name_and_tag<T>(writer, name, tag);
        return writer.get_buffer();
    }

    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const ByteTag& tag)
    {
        write_name_and_tag<ByteTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const ShortTag& tag)
    {
        write_name_and_tag<ShortTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const IntTag& tag)
    {
        write_name_and_tag<IntTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const LongTag& tag)
    {
        write_name_and_tag<LongTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const FloatTag& tag)
    {
        write_name_and_tag<FloatTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const DoubleTag& tag)
    {
        write_name_and_tag<DoubleTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const ByteArrayTag& tag)
    {
        write_name_and_tag<ByteArrayTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const StringTag& tag)
    {
        write_name_and_tag<StringTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const ListTag& tag)
    {
        write_name_and_tag<ListTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const CompoundTag& tag)
    {
        write_name_and_tag<CompoundTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const IntArrayTag& tag)
    {
        write_name_and_tag<IntArrayTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::optional<std::string>& name, const LongArrayTag& tag)
    {
        write_name_and_tag<LongArrayTag>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const std::string& name, const TagNode& tag)
    {
        write_name_and_tag<TagNode>(writer, name, tag);
    }
    void encode_nbt(BinaryWriter& writer, const NamedTag& tag)
    {
        write_name_and_tag<TagNode>(writer, tag.name, tag.tag_node);
    }

    std::string encode_nbt(const std::optional<std::string>& name, const ByteTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const ShortTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const IntTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const LongTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const FloatTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const DoubleTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const ByteArrayTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const StringTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const ListTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const CompoundTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const IntArrayTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    std::string encode_nbt(const std::optional<std::string>& name, const LongArrayTag& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    AMULET_NBT_EXPORT std::string encode_nbt(const std::string& name, const TagNode& tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return _encode_nbt(name, tag, endianness, string_encode);
    };
    AMULET_NBT_EXPORT std::string encode_nbt(const NamedTag& named_tag, std::endian endianness, Amulet::StringEncoder string_encode)
    {
        return encode_nbt(named_tag.name, named_tag.tag_node, endianness, string_encode);
    }
} // namespace NBT
} // namespace Amulet
