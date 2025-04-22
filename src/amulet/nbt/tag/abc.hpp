#pragma once

namespace Amulet {
namespace NBT {

    class AbstractBaseTag {
    public:
        virtual ~AbstractBaseTag() { };
    };

    class AbstractBaseImmutableTag : public AbstractBaseTag {
    public:
        virtual ~AbstractBaseImmutableTag() { };
    };
    class AbstractBaseMutableTag : public AbstractBaseTag {
    public:
        virtual ~AbstractBaseMutableTag() { };
    };
    class AbstractBaseNumericTag : public AbstractBaseImmutableTag {
    public:
        virtual ~AbstractBaseNumericTag() { };
    };
    class AbstractBaseIntTag : public AbstractBaseNumericTag {
    public:
        virtual ~AbstractBaseIntTag() { };
    };
    class AbstractBaseFloatTag : public AbstractBaseNumericTag {
    public:
        virtual ~AbstractBaseFloatTag() { };
    };
    class AbstractBaseArrayTag : public AbstractBaseMutableTag {
    public:
        virtual ~AbstractBaseArrayTag() { };
    };

#define FOR_EACH_LIST_TAG(MACRO)                                                                          \
    MACRO(1,   "byte",        ByteTag,       Amulet::NBT::ByteTag,          Amulet::NBT::ByteListTag)     \
    MACRO(2,   "short",       ShortTag,      Amulet::NBT::ShortTag,         Amulet::NBT::ShortListTag)    \
    MACRO(3,   "int",         IntTag,        Amulet::NBT::IntTag,           Amulet::NBT::IntListTag)      \
    MACRO(4,   "long",        LongTag,       Amulet::NBT::LongTag,          Amulet::NBT::LongListTag)     \
    MACRO(5,   "float",       FloatTag,      Amulet::NBT::FloatTag,         Amulet::NBT::FloatListTag)    \
    MACRO(6,   "double",      DoubleTag,     Amulet::NBT::DoubleTag,        Amulet::NBT::DoubleListTag)   \
    MACRO(7,   "byte_array",  ByteArrayTag,  Amulet::NBT::ByteArrayTagPtr,  Amulet::NBT::ByteArrayListTag)\
    MACRO(8,   "string",      StringTag,     Amulet::NBT::StringTag,        Amulet::NBT::StringListTag)   \
    MACRO(9,   "list",        ListTag,       Amulet::NBT::ListTagPtr,       Amulet::NBT::ListListTag)     \
    MACRO(10,  "compound",    CompoundTag,   Amulet::NBT::CompoundTagPtr,   Amulet::NBT::CompoundListTag) \
    MACRO(11,  "int_array",   IntArrayTag,   Amulet::NBT::IntArrayTagPtr,   Amulet::NBT::IntArrayListTag) \
    MACRO(12,  "long_array",  LongArrayTag,  Amulet::NBT::LongArrayTagPtr,  Amulet::NBT::LongArrayListTag)

#define FOR_EACH_LIST_TAG2(MACRO)                                   \
    MACRO(0, "end", std::monostate, std::monostate, std::monostate) \
    FOR_EACH_LIST_TAG(MACRO)
} // namespace NBT
} // namespace Amulet
