#pragma once

#include <string>
#include <vector>

std::vector<size_t> read_utf8(std::string& src);
void write_utf8(std::string &dst, std::vector<size_t> src);

std::string utf8_to_utf8(std::string& src);
