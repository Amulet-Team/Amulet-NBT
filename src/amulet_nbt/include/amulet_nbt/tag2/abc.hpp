#pragma once

#include <string>
#include <bit>

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
}
