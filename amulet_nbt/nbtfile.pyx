class NBTFile:
    __annotations__ = {'value': 'TAG_Compound', 'name': 'str'}

    def __init__(self, value=None, str name=""):
        self.value = TAG_Compound() if value is None else value
        self.name = name

    def to_snbt(self, indent_chr=None) -> str:
        return self.value.to_snbt(indent_chr)

    def save_to(self, filepath_or_buffer=None, compressed=True, little_endian=False) -> Optional[bytes]:
        buffer = BytesIO()
        self.value.write_payload(buffer, self.name, little_endian)
        data = buffer.getvalue()

        if compressed:
            gzip_buffer = BytesIO()
            with gzip.GzipFile(fileobj=gzip_buffer, mode='wb') as gz:
                gz.write(data)
            data = gzip_buffer.getvalue()

        if not filepath_or_buffer:
            return data

        if isinstance(filepath_or_buffer, str):
            with open(filepath_or_buffer, 'wb') as fp:
                fp.write(data)
        else:
            filepath_or_buffer.write(data)

    def __eq__(self, other):
        return isinstance(other, NBTFile) and self.value.__eq__(other.value) and self.name == other.name

    def __len__(self) -> int:
        return self.value.__len__()

    def keys(self):
        return self.value.keys()

    def values(self):
        self.value.values()

    def items(self):
        return self.value.items()

    def __getitem__(self, key: str) -> AnyNBT:
        return self.value[key]

    def __setitem__(self, key: str, tag: AnyNBT):
        self.value[key] = tag

    def __delitem__(self, key: str):
        del self.value[key]

    def __contains__(self, key: str) -> bool:
        return key in self.value

    def __repr__(self):
        return f'NBTFile("{self.name}":{self.to_snbt()})'

    def pop(self, k, default=None) -> AnyNBT:
        return self.value.pop(k, default)

    def get(self, k, default=None) -> AnyNBT:
        return self.value.get(k, default)
