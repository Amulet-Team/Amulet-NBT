#include <limits>
#include <stdexcept>
#include <string>
#include <string_view>

#include <zlib.h>

#include <amulet/nbt/zlib.hpp>

#define MAX_AVAIL_IN std::numeric_limits<uInt>::max()
#define DST_CHUNK_SIZE 65536
static_assert(MAX_AVAIL_IN <= std::numeric_limits<uInt>::max());
static_assert(DST_CHUNK_SIZE <= std::numeric_limits<uInt>::max());

namespace Amulet {
namespace NBT {

    void decompress_zlib_gzip(const std::string_view src, std::string& dst)
    {
        // Initialise the stream
        z_stream stream = { 0 };
        switch (inflateInit2(&stream, 32 + MAX_WBITS)) {
        case Z_MEM_ERROR:
            throw std::bad_alloc();
        case Z_VERSION_ERROR:
            throw std::runtime_error("Incompatible zlib library.");
        case Z_STREAM_ERROR:
            throw std::runtime_error("zlib stream is invalid.");
        }

        size_t src_index = 0;
        size_t dst_index = dst.size();
        int err;

        do {
            stream.avail_in = static_cast<uInt>(std::min<size_t>(src.size() - src_index, MAX_AVAIL_IN));
            if (stream.avail_in == 0) {
                break;
            }
            stream.next_in = reinterpret_cast<z_const Bytef*>(&src[src_index]);
            src_index += stream.avail_in;

            do {
                // allocate data after dst
                dst.resize(dst_index + DST_CHUNK_SIZE);
                // Assign the location to decompress into
                stream.next_out = reinterpret_cast<Bytef*>(&dst[dst_index]);
                stream.avail_out = DST_CHUNK_SIZE;

                // Decompress
                err = inflate(&stream, Z_NO_FLUSH);

                switch (err) {
                case Z_NEED_DICT:
                case Z_DATA_ERROR:
                    inflateEnd(&stream);
                    throw std::invalid_argument("Cannot decompress corrupt zlib data.");
                case Z_MEM_ERROR:
                    inflateEnd(&stream);
                    throw std::bad_alloc();
                case Z_STREAM_ERROR:
                    inflateEnd(&stream);
                    throw std::runtime_error("zlib stream is invalid.");
                }
                // increment dst_index
                dst_index += DST_CHUNK_SIZE - stream.avail_out;
            } while (stream.avail_out == 0);
        } while (err != Z_STREAM_END);

        // Remove unused bytes
        dst.resize(dst_index);
        // Clear stream data
        inflateEnd(&stream);
    }

    void compress_zlib(const std::string_view src, std::string& dst)
    {
        // Initialise the stream
        z_stream stream = { 0 };
        switch (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, 15, 8, Z_DEFAULT_STRATEGY)) {
        case Z_MEM_ERROR:
            throw std::bad_alloc();
        case Z_VERSION_ERROR:
            throw std::runtime_error("Incompatible zlib library.");
        case Z_STREAM_ERROR:
            throw std::runtime_error("zlib stream is invalid.");
        }

        size_t src_index = 0;
        size_t dst_index = dst.size();
        int err;
        int flush;

        do {
            stream.avail_in = static_cast<uInt>(std::min<size_t>(src.size() - src_index, MAX_AVAIL_IN));
            stream.next_in = reinterpret_cast<z_const Bytef*>(&src[src_index]);
            src_index += stream.avail_in;
            flush = (src.size() == src_index) ? Z_FINISH : Z_NO_FLUSH;

            do {
                // allocate data after dst
                dst.resize(dst_index + DST_CHUNK_SIZE);
                // Assign the location to decompress into
                stream.next_out = reinterpret_cast<Bytef*>(&dst[dst_index]);
                stream.avail_out = DST_CHUNK_SIZE;

                // Compress
                err = deflate(&stream, flush);
                if (err == Z_STREAM_ERROR) {
                    deflateEnd(&stream);
                    throw std::runtime_error("zlib stream is invalid.");
                }
                // increment dst_index
                dst_index += DST_CHUNK_SIZE - stream.avail_out;
            } while (stream.avail_out == 0);
        } while (src_index < src.size());

        // Remove unused bytes
        dst.resize(dst_index);
        // Clear stream data
        deflateEnd(&stream);
    }

    void compress_gzip(const std::string_view src, std::string& dst)
    {
        // Initialise the stream
        z_stream stream = { 0 };
        switch (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, 15 + 16, 8, Z_DEFAULT_STRATEGY)) {
        case Z_MEM_ERROR:
            throw std::bad_alloc();
        case Z_VERSION_ERROR:
            throw std::runtime_error("Incompatible zlib library.");
        case Z_STREAM_ERROR:
            throw std::runtime_error("zlib stream is invalid.");
        }

        size_t src_index = 0;
        size_t dst_index = dst.size();
        int err;
        int flush;

        do {
            stream.avail_in = static_cast<uInt>(std::min<size_t>(src.size() - src_index, MAX_AVAIL_IN));
            stream.next_in = reinterpret_cast<z_const Bytef*>(&src[src_index]);
            src_index += stream.avail_in;
            flush = (src.size() == src_index) ? Z_FINISH : Z_NO_FLUSH;

            do {
                // allocate data after dst
                dst.resize(dst_index + DST_CHUNK_SIZE);
                // Assign the location to decompress into
                stream.next_out = reinterpret_cast<Bytef*>(&dst[dst_index]);
                stream.avail_out = DST_CHUNK_SIZE;

                // Compress
                err = deflate(&stream, flush);
                if (err == Z_STREAM_ERROR) {
                    deflateEnd(&stream);
                    throw std::runtime_error("zlib stream is invalid.");
                }
                // increment dst_index
                dst_index += DST_CHUNK_SIZE - stream.avail_out;
            } while (stream.avail_out == 0);
        } while (src_index < src.size());

        // Remove unused bytes
        dst.resize(dst_index);
        // Clear stream data
        deflateEnd(&stream);
    }

} // namespace NBT
} // namespace Amulet
