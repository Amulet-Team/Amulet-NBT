#pragma once

#include <string>
#include <vector>

std::vector<size_t> read_mutf8(const std::string& src);
void write_mutf8(std::string& dst, const std::vector<size_t>& src);

std::string mutf8_to_utf8(const std::string& src);
std::string utf8_to_mutf8(const std::string& src);
