#################
 String Encoding
#################

There are a couple of different string encoding methods used in the different NBT formats.

The usual string encoding scheme is called UTF-8.

Bedrock Edition uses UTF-8 to encode strings but has been known to store non-UTF-8 byte sequences in TAG_String fields.

Java Edition uses a modified version of UTF-8 implemented by the Java programming language.

In order to handle the various encoding schemes an encoder/decoder function can be specified when reading or saving binary NBT data.

The following functions are provided to give to the read/write functions.

.. autofunction:: amulet_nbt.utf8_decoder
.. autofunction:: amulet_nbt.utf8_encoder
.. autofunction:: amulet_nbt.utf8_escape_decoder
.. autofunction:: amulet_nbt.utf8_escape_encoder


The mutf8 library is a third party library (not developed by us) used to encode and decode Modified UTF-8.

.. autofunction:: mutf8.decode_modified_utf8
.. autofunction:: mutf8.encode_modified_utf8
