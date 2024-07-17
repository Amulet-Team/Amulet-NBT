#pragma once

#include <string>
#include <bit>
#include <type_traits>
#include <variant>

#include <amulet_nbt/common.hpp>
#include <amulet_nbt/tag/nbt.hpp>
#include <amulet_nbt/nbt_encoding/binary.hpp>
#include <amulet_nbt/nbt_encoding/string.hpp>
#include <amulet_nbt/io/binary_writer.hpp>

namespace AmuletNBT {

    class AbstractBaseTag {
        public:
            virtual ~AbstractBaseTag(){};
            virtual std::string to_nbt(std::string, std::endian, AmuletNBT::StringEncode) const = 0;
            virtual std::string to_snbt() const = 0;
            virtual std::string to_snbt(const std::string& indent) const = 0;
    };

    class AbstractBaseImmutableTag: public AbstractBaseTag {
        public:
            virtual ~AbstractBaseImmutableTag(){};
    };
    class AbstractBaseMutableTag: public AbstractBaseTag {
        public:
            virtual ~AbstractBaseMutableTag(){};
    };
    class AbstractBaseNumericTag: public AbstractBaseImmutableTag {
        public:
            virtual ~AbstractBaseNumericTag(){};
    };
    class AbstractBaseIntTag: public AbstractBaseNumericTag {
        public:
            virtual ~AbstractBaseIntTag(){};
    };
    class AbstractBaseFloatTag: public AbstractBaseNumericTag {
        public:
            virtual ~AbstractBaseFloatTag(){};
    };
    class AbstractBaseArrayTag: public AbstractBaseMutableTag {
        public:
            virtual ~AbstractBaseArrayTag(){};
    };

    // pybind cannot directly store fundamental types
    // This wrapper exists to allow pybind to store fundamental types
    template <typename T>
    class TagWrapper: public
        std::conditional_t<std::is_same_v<T, ByteTag>, AbstractBaseIntTag,
        std::conditional_t<std::is_same_v<T, ShortTag>, AbstractBaseIntTag,
        std::conditional_t<std::is_same_v<T, IntTag>, AbstractBaseIntTag,
        std::conditional_t<std::is_same_v<T, LongTag>, AbstractBaseIntTag,
        std::conditional_t<std::is_same_v<T, FloatTag>, AbstractBaseFloatTag,
        std::conditional_t<std::is_same_v<T, DoubleTag>, AbstractBaseFloatTag,
        std::conditional_t<std::is_same_v<T, ByteArrayTagPtr>, AbstractBaseArrayTag,
        std::conditional_t<std::is_same_v<T, StringTag>, AbstractBaseImmutableTag,
        std::conditional_t<std::is_same_v<T, ListTagPtr>, AbstractBaseMutableTag,
        std::conditional_t<std::is_same_v<T, CompoundTagPtr>, AbstractBaseMutableTag,
        std::conditional_t<std::is_same_v<T, IntArrayTagPtr>, AbstractBaseArrayTag,
        std::conditional_t<std::is_same_v<T, LongArrayTagPtr>, AbstractBaseArrayTag,
        void
    >>>>>>>>>>>> {
        public:
            T tag;
            TagWrapper(T tag): tag(tag) {};
            virtual std::string to_nbt(std::string name, std::endian endianness, AmuletNBT::StringEncode string_encode) const {
                return AmuletNBT::write_nbt(name, tag, endianness, string_encode);
            }
            virtual std::string to_snbt() const {
                if constexpr (is_shared_ptr<T>::value){
                    return AmuletNBT::write_snbt(*tag);
                } else {
                    return AmuletNBT::write_snbt(tag);
                }
            }
            virtual std::string to_snbt(const std::string& indent) const {
                if constexpr (is_shared_ptr<T>::value){
                    return AmuletNBT::write_formatted_snbt(*tag, indent);
                } else {
                    return AmuletNBT::write_formatted_snbt(tag, indent);
                }
            }
    };
    typedef TagWrapper<ByteTag> ByteTagWrapper;
    typedef TagWrapper<ShortTag> ShortTagWrapper;
    typedef TagWrapper<IntTag> IntTagWrapper;
    typedef TagWrapper<LongTag> LongTagWrapper;
    typedef TagWrapper<FloatTag> FloatTagWrapper;
    typedef TagWrapper<DoubleTag> DoubleTagWrapper;
    typedef TagWrapper<ByteArrayTagPtr> ByteArrayTagWrapper;
    typedef TagWrapper<StringTag> StringTagWrapper;
    typedef TagWrapper<ListTagPtr> ListTagWrapper;
    typedef TagWrapper<CompoundTagPtr> CompoundTagWrapper;
    typedef TagWrapper<IntArrayTagPtr> IntArrayTagWrapper;
    typedef TagWrapper<LongArrayTagPtr> LongArrayTagWrapper;

    typedef std::variant<
        std::monostate,
        ByteTagWrapper,
        ShortTagWrapper,
        IntTagWrapper,
        LongTagWrapper,
        FloatTagWrapper,
        DoubleTagWrapper,
        ByteArrayTagWrapper,
        StringTagWrapper,
        ListTagWrapper,
        CompoundTagWrapper,
        IntArrayTagWrapper,
        LongArrayTagWrapper
    > WrapperNode;

    WrapperNode wrap_node(AmuletNBT::TagNode node);
    AmuletNBT::TagNode unwrap_node(WrapperNode node);
}
