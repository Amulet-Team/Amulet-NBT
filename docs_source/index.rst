########################################
 Welcome to Amulet NBT's documentation!
########################################

.. toctree::
   :maxdepth: 4
   :caption: Contents:

   getting_started


.. inheritance-diagram:: amulet_nbt.ByteTag
                         amulet_nbt.ShortTag
                         amulet_nbt.IntTag
                         amulet_nbt.LongTag
                         amulet_nbt.FloatTag
                         amulet_nbt.DoubleTag
                         amulet_nbt.StringTag
                         amulet_nbt.ListTag
                         amulet_nbt.CompoundTag
                         amulet_nbt.ByteArrayTag
                         amulet_nbt.IntArrayTag
                         amulet_nbt.LongArrayTag
                         amulet_nbt.NamedTag
   :top-classes: collections.abc.MutableSequence, collections.abc.MutableMapping
   :parts: 1


#############
 Tag Classes
#############

.. autoclass:: amulet_nbt.ByteTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:
   :member-order: bysource

.. autoclass:: amulet_nbt.ShortTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.IntTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.LongTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.FloatTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.DoubleTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.StringTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.ListTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.CompoundTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.ByteArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.IntArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.LongArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:


##########################################
 :class:`amulet_nbt.NamedTag` class
##########################################

.. autoclass:: amulet_nbt.NamedTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:


#######################
 Abstract Base Classes
#######################

.. autoclass:: amulet_nbt.AbstractBaseTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:

.. autoclass:: amulet_nbt.AbstractBaseImmutableTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.AbstractBaseMutableTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.AbstractBaseNumericTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.AbstractBaseIntTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.AbstractBaseFloatTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:

.. autoclass:: amulet_nbt.AbstractBaseArrayTag
   :members:
   :inherited-members:
   :undoc-members:
   :special-members:
   :show-inheritance:


##########
 load nbt
##########

These are functions to load the binary and stringified NBT formats.

.. autofunction:: amulet_nbt.load
.. autofunction:: amulet_nbt.load_array
.. autoclass:: amulet_nbt.ReadOffset
   :members:
.. autofunction:: amulet_nbt.from_snbt


############
 Exceptions
############

.. autoexception:: amulet_nbt.NBTError
.. autoexception:: amulet_nbt.NBTLoadError
   :show-inheritance:
.. autoexception:: amulet_nbt.NBTFormatError
   :show-inheritance:
.. autoexception:: amulet_nbt.SNBTParseError
   :show-inheritance:


#################
 String Encoding
#################

These are instances of a class storing C++ functions to encode and decode strings.

.. autoclass:: amulet_nbt.StringEncoding
   :members:
   :inherited-members:
   :undoc-members:

They can be passed to the string_encoding argument in to_nbt, save_to, load and load_array to control the string encoding behaviour.

The usual string encoding scheme is called UTF-8.

.. autodata:: amulet_nbt.utf8_encoding

Bedrock Edition uses UTF-8 to encode strings but has been known to store non-UTF-8 byte sequences in TAG_String fields.
amulet_nbt.utf8_escape_encoding will escape invalid UTF-8 bytes as ␛xHH

.. autodata:: amulet_nbt.utf8_escape_encoding

Java Edition uses a modified version of UTF-8 implemented by the Java programming language.

.. autodata:: amulet_nbt.mutf8_encoding


##################
 Encoding Presets
##################

The string encoding and endianness can be defined separatly but for simplicity the following presets have been defined.

.. autodata:: amulet_nbt.java_encoding
.. autodata:: amulet_nbt.bedrock_encoding


####################
 Indices and tables
####################

-  :ref:`genindex`
