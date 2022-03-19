"""Cython has a template language called tempita.
This bakes the template files into real cython files."""
import glob
import os
import pkgutil

from Cython import Tempita as tempita


TEMPLATE_ROOT_PATH = os.path.dirname(pkgutil.get_loader("template").get_filename())
TEMPLATES_PATH = os.path.join(TEMPLATE_ROOT_PATH, "templates")
SRC_PATH = os.path.join(TEMPLATE_ROOT_PATH, "src")

NBT_ROOT_PATH = os.path.dirname(pkgutil.get_loader("amulet_nbt").get_filename())


def include(rel_path, **kwargs):
    """
    Load and bake a template file.

    :param rel_path: The path relative to the root.
    :return: The baked cython code.
    """
    with open(os.path.join(TEMPLATES_PATH, rel_path)) as f:
        return tempita.sub(f.read(), **kwargs)


def build():
    for path in glob.glob(
        os.path.join(SRC_PATH, "**", "*.*"), recursive=True
    ):
        rel_path = os.path.relpath(path, SRC_PATH)
        print(f"Baking tempita file {rel_path}")
        with open(path) as template:
            cy_code = tempita.sub(template.read())
        save_path = os.path.join(NBT_ROOT_PATH, rel_path)
        changed = True
        if os.path.isfile(save_path):
            with open(save_path) as cy:
                changed = cy.read() != cy_code
        if changed:
            with open(save_path, "w") as cy:
                cy.write(cy_code)
