#pragma once

namespace AmuletNBT {

    class AbstractBaseTag {
        public:
            virtual ~AbstractBaseTag(){};
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

    #define FOR_EACH_LIST_TAG(MACRO)\
            MACRO(1,   "byte",        ByteTag,       AmuletNBT::ByteTag,          AmuletNBT::ByteListTag)\
            MACRO(2,   "short",       ShortTag,      AmuletNBT::ShortTag,         AmuletNBT::ShortListTag)\
            MACRO(3,   "int",         IntTag,        AmuletNBT::IntTag,           AmuletNBT::IntListTag)\
            MACRO(4,   "long",        LongTag,       AmuletNBT::LongTag,          AmuletNBT::LongListTag)\
            MACRO(5,   "float",       FloatTag,      AmuletNBT::FloatTag,         AmuletNBT::FloatListTag)\
            MACRO(6,   "double",      DoubleTag,     AmuletNBT::DoubleTag,        AmuletNBT::DoubleListTag)\
            MACRO(7,   "byte_array",  ByteArrayTag,  AmuletNBT::ByteArrayTagPtr,  AmuletNBT::ByteArrayListTag)\
            MACRO(8,   "string",      StringTag,     AmuletNBT::StringTag,        AmuletNBT::StringListTag)\
            MACRO(9,   "list",        ListTag,       AmuletNBT::ListTagPtr,       AmuletNBT::ListListTag)\
            MACRO(10,  "compound",    CompoundTag,   AmuletNBT::CompoundTagPtr,   AmuletNBT::CompoundListTag)\
            MACRO(11,  "int_array",   IntArrayTag,   AmuletNBT::IntArrayTagPtr,   AmuletNBT::IntArrayListTag)\
            MACRO(12,  "long_array",  LongArrayTag,  AmuletNBT::LongArrayTagPtr,  AmuletNBT::LongArrayListTag)

    #define FOR_EACH_LIST_TAG2(MACRO)\
            MACRO(0, "end", std::monostate, std::monostate, std::monostate)\
            FOR_EACH_LIST_TAG(MACRO)
}
