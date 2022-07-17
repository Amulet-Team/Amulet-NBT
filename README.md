# Amulet-NBT

![Build](../../workflows/Build/badge.svg)
![Unittests](../../workflows/Unittests/badge.svg?event=push)
![Stylecheck](../../workflows/Stylecheck/badge.svg?event=push)

Amulet-NBT is a Python 3 library, written in Cython, for reading and writing both binary NBT and SNBT.

SNBT (or Stringified-NBT) is the JSON like format used in Java commands.

## Installing

Run this command to install from PyPi.

`pip install amulet-nbt~=2.0`

## Documentation

See our [readthedocs site](https://amulet-nbt.readthedocs.io) for the full documentation of this library.

## Development

To develop the library you will need to download the source and run this command from the root directory.

`pip install -e .[dev]`

This will build the library in-place and expose it to python.
Since this code is compiled you will need to run it again each time you change cython code.

## Links
- Documentation - https://amulet-nbt.readthedocs.io
- Github - https://github.com/Amulet-Team/Amulet-NBT
- Website - https://www.amuletmc.com/
