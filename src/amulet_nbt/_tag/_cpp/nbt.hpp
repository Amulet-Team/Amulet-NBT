#pragma once

#include <cstdint>
#include <string>
#include <vector>
#include <unordered_map>
#include <variant>
#include <memory>
#include "array.hpp"


// Base types
typedef std::int8_t CByteTag;
typedef std::int16_t CShortTag;
typedef std::int32_t CIntTag;
typedef std::int64_t CLongTag;
typedef float CFloatTag;
typedef double CDoubleTag;
typedef Array<CByteTag> CByteArrayTag;
typedef std::string CStringTag;
class CListTag;
class CCompoundTag;
typedef Array<CIntTag> CIntArrayTag;
typedef Array<CLongTag> CLongArrayTag;

// Pointer types
typedef std::shared_ptr<CListTag> CListTagPtr;
typedef std::shared_ptr<CCompoundTag> CCompoundTagPtr;
typedef std::shared_ptr<CByteArrayTag> CByteArrayTagPtr;
typedef std::shared_ptr<CIntArrayTag> CIntArrayTagPtr;
typedef std::shared_ptr<CLongArrayTag> CLongArrayTagPtr;

// List types
typedef std::vector<CByteTag> CByteList;
typedef std::vector<CShortTag> CShortList;
typedef std::vector<CIntTag> CIntList;
typedef std::vector<CLongTag> CLongList;
typedef std::vector<CFloatTag> CFloatList;
typedef std::vector<CDoubleTag> CDoubleList;
typedef std::vector<CByteArrayTagPtr> CByteArrayList;
typedef std::vector<CStringTag> CStringList;
typedef std::vector<CListTagPtr> CListList;
typedef std::vector<CCompoundTagPtr> CCompoundList;
typedef std::vector<CIntArrayTagPtr> CIntArrayList;
typedef std::vector<CLongArrayTagPtr> CLongArrayList;

class CListTag : public std::variant<
    std::monostate,
    CByteList,
    CShortList,
    CIntList,
    CLongList,
    CFloatList,
    CDoubleList,
    CByteArrayList,
    CStringList,
    CListList,
    CCompoundList,
    CIntArrayList,
    CLongArrayList
> {
    using variant::variant;
};

typedef std::variant<
    std::monostate,
    CByteTag,
    CShortTag,
    CIntTag,
    CLongTag,
    CFloatTag,
    CDoubleTag,
    CByteArrayTagPtr,
    CStringTag,
    CListTagPtr,
    CCompoundTagPtr,
    CIntArrayTagPtr,
    CLongArrayTagPtr
> TagNode;

class CCompoundTag : public std::unordered_map<std::string, TagNode> {
    using unordered_map::unordered_map;
};
