#pragma once

#include <string>
#include <vector>

namespace Amulet {
    std::string utf8_to_utf8(const std::string& src);
    std::string utf8_escape_to_utf8(const std::string& src);
    std::string utf8_to_utf8_escape(const std::string& src);
    std::string mutf8_to_utf8(const std::string& src);
    std::string utf8_to_mutf8(const std::string& src);
}
