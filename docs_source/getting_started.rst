########################################
 Getting Started Guide
########################################

.. code-block:: python
   :linenos:

   # Import the nbt library
   # Option 1 - import the package then refer to attributes on the package
   import amulet_nbt

   # Option 2 - import attributes from the package
   from amulet_nbt import (
      ByteTag,
      ShortTag,
      IntTag,
      LongTag,
      FloatTag,
      DoubleTag,
      StringTag,
      ListTag,
      CompoundTag,
      ByteArrayTag,
      IntArrayTag,
      LongArrayTag,
      NamedTag,
      mutf8_encoding,
      utf8_encoding,
      utf8_escape_encoding,
      java_encoding,
      bedrock_encoding,
   )

   # These classes are also available under their old names
   # from amulet_nbt import (
   #    TAG_Byte,
   #    TAG_Short,
   #    TAG_Int,
   #    TAG_Long,
   #    TAG_Float,
   #    TAG_Double,
   #    TAG_String,
   #    TAG_List,
   #    TAG_Compound,
   #    TAG_Byte_Array,
   #    TAG_Int_Array,
   #    TAG_Long_Array
   # )

   named_tag: NamedTag
   java_named_tag: NamedTag
   bedrock_named_tag: NamedTag

   # Load binary NBT
   named_tag = amulet_nbt.read_nbt(
      "the/path/to/your/binary/nbt/file",
      preset=java_encoding,
      compressed=True,  # These inputs must be specified as keyword inputs like this.
   )  # from a file
   named_tag = amulet_nbt.read_nbt(
      "the/path/to/your/binary/nbt/file",
      compressed=True,  # These inputs must be specified as keyword inputs like this.
      little_endian=False,  # If you do not define them they will default to these values
      string_encoding=mutf8_encoding
   )  # from a file
   named_tag = amulet_nbt.read_nbt(b'<nbt file bytes>')  # from a bytes object

   # Note that Java Edition usually uses compressed modified UTF-8.
   java_named_tag = amulet_nbt.read_nbt(
      "the/path/to/your/binary/java/nbt/file",
      string_encoding=mutf8_encoding
   )

   # Bedrock edition data is stored in little endian format and uses non-compressed UTF-8 but can also have arbitrary bytes.
   bedrock_named_tag = amulet_nbt.read_nbt(
      "the/path/to/your/binary/bedrock/nbt/file",
      preset=bedrock_encoding,
      compressed=False,
   )
   bedrock_named_tag = amulet_nbt.read_nbt(
      "the/path/to/your/binary/bedrock/nbt/file",
      compressed=False,
      little_endian=True,
      string_encoding=utf8_escape_encoding  # This decoder will escape all invalid bytes to the string ␛xHH
   )

   # Save the data back to a file
   named_tag.save_to(
      "the/path/to/write/to",
      compressed=True,  # These inputs must be specified as keyword inputs like this.
      preset=java_encoding
   )
   named_tag.save_to(
      "the/path/to/write/to",
      compressed=True,  # These inputs must be specified as keyword inputs like this.
      little_endian=False,  # If you do not define them they will default to these values
      string_encoding=mutf8_encoding
   )

   # save_to can also be given a file object to write to.
   with open('filepath', 'wb') as f:
      named_tag.save_to(f)

   # Like earlier you will need to give the correct options for the platform you are using.
   # Java
   java_named_tag.save_to(
      "the/path/to/write/to",
      preset=java_encoding
   )

   # Bedrock
   bedrock_named_tag.save_to(
      "the/path/to/write/to",
      compressed=False,
      preset=bedrock_encoding
   )


   # You can also parse the stringified NBT format used in Java commands.
   tag = amulet_nbt.read_snbt('{key1: "value", key2: 0b, key3: 0.0f}')
   # tag should look like this
   # TAG_Compound(
   #   key1: TAG_String("value"),
   #   key2: TAG_Byte(0)
   #   key3: TAG_Float(0.0)
   # )

   # Tags can be saved like the NamedTag class but they do not have a name.
   tag.save_to(
      'filepath',
      # see the NamedTag save_to documentation above for other options.
      name=""  # Tag classes do not store their name so you can define it here.
   )
   tag.to_snbt()  # convert back to SNBT

   # The classes can also be constructed manually like this
   tag = CompoundTag({
      "key1": ByteTag(0),  # if no input value is given it will automatically fill these defaults
      "key2": ShortTag(0),
      "key3": IntTag(0),
      "key4": LongTag(0),
      "key5": FloatTag(0.0),
      "key6": DoubleTag(0.0),
      "key7": ByteArrayTag([]),
      "key8": StringTag(""),
      "key9": ListTag([]),
      "key10": CompoundTag({}),
      "key11": IntArrayTag([]),
      "key12": LongArrayTag([])
   })

   named_tag = NamedTag(
      tag,
      name=""  # Optional name input.
   )
