"""Cython has a template language called tempita.
This bakes the template files into real cython files."""

import glob
import os
from typing import Optional

from Cython import Tempita as tempita


ROOT_PATH = os.path.dirname(__file__)
SRC_PATH = os.path.join(ROOT_PATH, "src")


def include(rel_path, **kwargs):
    """
    Load and bake a template file.

    :param rel_path: The path relative to the root.
    :return: The baked cython code.
    """
    with open(os.path.join(SRC_PATH, rel_path)) as f:
        return tempita.sub(f.read(), **kwargs)


class TempitaManager:
    def __init__(self) -> None:
        self.files: list[TempitaFile] = []
        for path in glob.glob(os.path.join(SRC_PATH, "**", "*.tp"), recursive=True):
            rel_path = os.path.relpath(path, SRC_PATH)
            save_path = path[:-3]
            self.files.append(TempitaFile(path, rel_path, save_path))

    def changed(self) -> bool:
        return any(file.changed for file in self.files)

    def build(self) -> None:
        for file in self.files:
            file.build()


class TempitaFile:
    def __init__(self, src_path: str, rel_path: str, save_path: str):
        self.src_path = src_path
        self.rel_path = rel_path
        self.save_path = save_path

    @property
    def baked(self) -> str:
        """The result when the template is baked out."""
        with open(self.src_path) as template:
            return tempita.sub(template.read())

    @property
    def written(self) -> Optional[str]:
        """The previously baked out code (if any)"""
        if os.path.isfile(self.save_path):
            with open(self.save_path) as f:
                return f.read()
        return None

    @property
    def changed(self) -> bool:
        """Has the source changed since the last bake."""
        return self.baked != self.written

    def build(self) -> None:
        """Build all changes and overwrite the previous bake."""
        print(f"Baking tempita file {self.rel_path}")
        baked = self.baked
        written = self.written
        if baked != written:
            with open(self.save_path, "w") as cy:
                cy.write(baked)


def changed() -> bool:
    """Have the source files changed since the last time tempita was run."""
    return TempitaManager().changed()


if __name__ == "__main__":
    TempitaManager().build()
