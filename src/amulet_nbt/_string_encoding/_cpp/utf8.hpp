#pragma once

#include <string>
#include <vector>

std::vector<size_t> read_utf8(const std::string& src);
void write_utf8(std::string &dst, const std::vector<size_t>& src);

std::string utf8_to_utf8(const std::string& src);

std::vector<size_t> read_utf8_escape(const std::string& src);
void write_utf8_escape(std::string &dst, const std::vector<size_t>& src);

std::string utf8_escape_to_utf8(const std::string& src);
std::string utf8_to_utf8_escape(const std::string& src);
