#include <stdexcept>
#include <string>
#include <string_view>

#include <zlib.h>

#include <amulet_nbt/zlib.hpp>

namespace AmuletNBT {

void decompress_zlib_gzip(const std::string_view src, std::string& dst)
{
    z_stream stream = {};
    stream.next_in = reinterpret_cast<z_const Bytef*>(src.data());
    stream.avail_in = static_cast<uInt>(src.size());

    switch (inflateInit2(&stream, 32 + MAX_WBITS)) {
    case Z_MEM_ERROR:
        throw std::bad_alloc();
    case Z_VERSION_ERROR:
        throw std::runtime_error("Incompatible zlib library.");
    case Z_STREAM_ERROR:
        throw std::runtime_error("zlib stream is invalid.");
    }

    const size_t chunk_size = 65536;
    int err;
    size_t start_dst_size = dst.size();

    do {
        // allocate data after dst
        size_t dst_size = dst.size();
        dst.resize(dst_size + chunk_size);

        // Assign the location to decompress into
        stream.next_out = reinterpret_cast<Bytef*>(&dst[dst_size]);
        stream.avail_out = chunk_size;

        // Decompress
        err = inflate(&stream, Z_NO_FLUSH);

        // Continue until error or end of stream.
    } while (err == Z_OK);

    // Remove unused bytes
    dst.resize(start_dst_size + stream.total_out);
    // Clear stream data
    inflateEnd(&stream);

    switch (err) {
    case Z_STREAM_END:
        return;
    case Z_DATA_ERROR:
        throw std::invalid_argument("Cannot decompress corrupt zlib data.");
    case Z_MEM_ERROR:
        throw std::bad_alloc();
    case Z_STREAM_ERROR:
        throw std::runtime_error("zlib stream is invalid.");
    case Z_BUF_ERROR:
        throw std::runtime_error("Decompression requires a larger buffer than the one provided.");
    default:
        throw std::runtime_error("zlib decompression error.");
    }
}

void compress_zlib(const std::string_view src, std::string& dst)
{
    // Get the src size.
    uLong source_length = static_cast<uLong>(src.size());
    // Get the maximum compressed size.
    uLongf compressed_size = compressBound(source_length);

    // Get the starting size of dst.
    size_t dst_size = dst.size();
    // Resize dst so it can fit the maximum compressed size.
    dst.resize(dst_size + compressed_size);

    // Compress
    if (compress(reinterpret_cast<Bytef*>(&dst[dst_size]), &compressed_size, reinterpret_cast<const Bytef*>(src.data()), source_length) != Z_OK) {
        throw std::runtime_error("Error compressing data.");
    };
    // Compress modifies compressed size. Resize to the real size.
    dst.resize(dst_size + compressed_size);
}

void compress_gzip(const std::string_view src, std::string& dst)
{
    z_stream stream = { 0 };

    switch (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, 15 + 16, 8, Z_DEFAULT_STRATEGY)) {
    case Z_MEM_ERROR:
        throw std::bad_alloc();
    case Z_VERSION_ERROR:
        throw std::runtime_error("Incompatible zlib library.");
    case Z_STREAM_ERROR:
        throw std::runtime_error("zlib stream is invalid.");
    }

    stream.next_in = reinterpret_cast<z_const Bytef*>(src.data());
    stream.avail_in = static_cast<uInt>(src.size());

    const size_t chunk_size = 65536;
    int err;
    size_t start_dst_size = dst.size();

    do {
        // allocate data after dst
        size_t dst_size = dst.size();
        dst.resize(dst_size + chunk_size);

        // Assign the location to compress into
        stream.next_out = reinterpret_cast<Bytef*>(&dst[dst_size]);
        stream.avail_out = chunk_size;

        // Compress
        err = deflate(&stream, Z_FINISH);
    
        // Continue until error or end of stream.
    } while (err == Z_OK);

    // Remove unused bytes
    dst.resize(start_dst_size + stream.total_out);
    // Clear stream data
    deflateEnd(&stream);

    switch (err) {
    case Z_STREAM_END:
        return;
    case Z_STREAM_ERROR:
        throw std::runtime_error("zlib stream is invalid.");
    default:
        throw std::runtime_error("zlib decompression error.");
    }
}

} // namespace AmuletNBT
