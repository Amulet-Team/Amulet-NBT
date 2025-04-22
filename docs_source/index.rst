########################################
 Welcome to Amulet NBT's documentation!
########################################

.. toctree::
   :maxdepth: 4
   :caption: Contents:

   getting_started


.. inheritance-diagram:: amulet.nbt.ByteTag
                         amulet.nbt.ShortTag
                         amulet.nbt.IntTag
                         amulet.nbt.LongTag
                         amulet.nbt.FloatTag
                         amulet.nbt.DoubleTag
                         amulet.nbt.StringTag
                         amulet.nbt.ListTag
                         amulet.nbt.CompoundTag
                         amulet.nbt.ByteArrayTag
                         amulet.nbt.IntArrayTag
                         amulet.nbt.LongArrayTag
                         amulet.nbt.NamedTag
   :top-classes: collections.abc.MutableSequence, collections.abc.MutableMapping
   :parts: 1


#############
 Tag Classes
#############

.. autoclass:: amulet.nbt.ByteTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:
   :member-order: bysource

.. autoclass:: amulet.nbt.ShortTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.IntTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.LongTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.FloatTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.DoubleTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.StringTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.ListTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.CompoundTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.ByteArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.IntArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.LongArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:


##########################################
 :class:`amulet.nbt.NamedTag` class
##########################################

.. autoclass:: amulet.nbt.NamedTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:


#######################
 Abstract Base Classes
#######################

.. autoclass:: amulet.nbt.AbstractBaseTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:

.. autoclass:: amulet.nbt.AbstractBaseImmutableTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.AbstractBaseMutableTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.AbstractBaseNumericTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.AbstractBaseIntTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.AbstractBaseFloatTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet.nbt.AbstractBaseArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:


##########
 load nbt
##########

These are functions to load the binary and stringified NBT formats.

.. autofunction:: amulet.nbt.read_nbt
.. autofunction:: amulet.nbt.read_nbt_array
.. autoclass:: amulet.nbt.ReadOffset
   :members:
.. autofunction:: amulet.nbt.read_snbt


#################
 String Encoding
#################

These are instances of a class storing C++ functions to encode and decode strings.

.. autoclass:: amulet.nbt.StringEncoding
   :members:
   :inherited-members:
   :undoc-members:

They can be passed to the string_encoding argument in to_nbt, save_to, read_nbt and read_nbt_array to control the string encoding behaviour.

The usual string encoding scheme is called UTF-8.

.. autodata:: amulet.nbt.utf8_encoding

Bedrock Edition uses UTF-8 to encode strings but has been known to store non-UTF-8 byte sequences in TAG_String fields.
amulet.nbt.utf8_escape_encoding will escape invalid UTF-8 bytes as ␛xHH

.. autodata:: amulet.nbt.utf8_escape_encoding

Java Edition uses a modified version of UTF-8 implemented by the Java programming language.

.. autodata:: amulet.nbt.mutf8_encoding


##################
 Encoding Presets
##################

The string encoding and endianness can be defined separately but for simplicity the following presets have been defined.

.. autodata:: amulet.nbt.java_encoding
.. autodata:: amulet.nbt.bedrock_encoding


####################
 Indices and tables
####################

-  :ref:`genindex`
