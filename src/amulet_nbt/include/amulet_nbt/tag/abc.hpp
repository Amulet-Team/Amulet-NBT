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
}
