#include <amulet_nbt/tag/compound.hpp>

namespace Amulet {
    CompoundTagIterator::CompoundTagIterator(
        Amulet::CompoundTagPtr tag
    ): tag(tag), begin(tag->begin()), end(tag->end()), pos(tag->begin()), size(tag->size()) {};

    std::string CompoundTagIterator::next(){
        if (!is_valid()){
            throw std::exception("CompoundTag changed size during iteration.");
        }
        return (pos++)->first;
    };

    bool CompoundTagIterator::has_next(){
        return pos != end;
    };

    bool CompoundTagIterator::is_valid(){
        // This is not fool proof.
        // There are cases where this is true but the iterator is invalid.
        // The programmer should write good code and this will catch some of the bad cases.
        return size == tag->size() && begin == tag->begin() && end == tag->end();
    };
}
