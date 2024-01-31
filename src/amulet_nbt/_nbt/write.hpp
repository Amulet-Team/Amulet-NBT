#pragma once

#include <string>
#include <bit>
#include <variant>
#include <stdexcept>

#include "../_binary/writer.hpp"
#include "nbt.hpp"
#include "array.hpp"

// Write a name and TagNode to a binary sequence
std::string write_named_tag(const std::string&, const TagNode&, std::endian);
