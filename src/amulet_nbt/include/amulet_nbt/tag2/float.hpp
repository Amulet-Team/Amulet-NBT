#pragma once

#include <cstdint>

#include <amulet_nbt/tag2/abc.hpp>

namespace AmuletNBT {
    template <typename T>
    class FloatTagTemplate: public AbstractBaseFloatTag {
        public:
            const T value;

            FloatTagTemplate();
            FloatTagTemplate(T&);
    };

    typedef IntTagTemplate<float> FloatTag;
    typedef IntTagTemplate<double> DoubleTag;
}
