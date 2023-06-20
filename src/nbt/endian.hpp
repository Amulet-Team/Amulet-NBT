#include <bit>

template <typename T>
void swap_endian(T &val) {
    union U {
        T val;
        std::array<std::uint8_t, sizeof(T)> raw;
    } src, dst;

    src.val = val;
    std::reverse_copy(src.raw.begin(), src.raw.end(), dst.raw.begin());
    val = dst.val;
}

template <typename T>
void swap_to_endian(T &val, std::endian endianness) {
    if (std::endian::native != endianness){
        swap_endian(val);
    }
}

template <typename Container, typename Element>
void swap_array_to_endian(Container[Element] &val, std::endian endianness) {
    if (std::endian::native != endianness){
        for (Element & element : val){
            swap_endian(element);
        }
    }
}
