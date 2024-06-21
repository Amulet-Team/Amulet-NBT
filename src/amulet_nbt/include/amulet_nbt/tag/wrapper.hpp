#pragma once

#include "nbt.hpp"

namespace Amulet {

    class AbstractBaseTag {
    };

    class AbstractBaseImmutableTag: public AbstractBaseTag {};
    class AbstractBaseMutableTag: public AbstractBaseTag {};
    class AbstractBaseNumericTag: public AbstractBaseImmutableTag {};
    class AbstractBaseIntTag: public AbstractBaseNumericTag {};
    class AbstractBaseFloatTag: public AbstractBaseNumericTag {};
    class AbstractBaseArrayTag: public AbstractBaseMutableTag {};

    // pybind cannot directly store fundamental types
    // This wrapper exists to allow pybind to store fundamental types
    template <typename BaseClassT, typename T>
    class TagWrapper: public BaseClassT {
        public:
            T tag;
            TagWrapper(T tag): tag(tag) {};
    };
    typedef TagWrapper<AbstractBaseIntTag, ByteTag> ByteTagWrapper;
    typedef TagWrapper<AbstractBaseIntTag, ShortTag> ShortTagWrapper;
    typedef TagWrapper<AbstractBaseIntTag, IntTag> IntTagWrapper;
    typedef TagWrapper<AbstractBaseIntTag, LongTag> LongTagWrapper;
    typedef TagWrapper<AbstractBaseFloatTag, FloatTag> FloatTagWrapper;
    typedef TagWrapper<AbstractBaseFloatTag, DoubleTag> DoubleTagWrapper;
    typedef TagWrapper<AbstractBaseArrayTag, ByteArrayTagPtr> ByteArrayTagWrapper;
    typedef TagWrapper<AbstractBaseImmutableTag, StringTag> StringTagWrapper;
    typedef TagWrapper<AbstractBaseMutableTag, ListTagPtr> ListTagWrapper;
    typedef TagWrapper<AbstractBaseMutableTag, CompoundTagPtr> CompoundTagWrapper;
    typedef TagWrapper<AbstractBaseArrayTag, IntArrayTagPtr> IntArrayTagWrapper;
    typedef TagWrapper<AbstractBaseArrayTag, LongArrayTagPtr> LongArrayTagWrapper;
}
