"""Cython has a template language called tempita.
This bakes the template files into real cython files."""
import glob
import os
from Cython import Tempita as tempita

ROOT_PATH = os.path.dirname(os.path.dirname(__file__))


def include(rel_path, **kwargs):
    """
    Load and bake a template file.

    :param rel_path: The path relative to the root.
    :return: The baked cython code.
    """
    with open(os.path.join(ROOT_PATH, rel_path)) as f:
        return tempita.sub(f.read(), **kwargs)


def main():
    for path in glob.glob(
        os.path.join(ROOT_PATH, "amulet_nbt", "**", "*.pyx.in"), recursive=True
    ):
        if os.path.basename(path).islower():
            print(f"Baking tempita file {path}")
            with open(path) as template:
                cy_code = tempita.sub(template.read())
            cy_path = path[:-3]
            with open(cy_path) as cy:
                changed = cy.read() != cy_code
            if changed:
                with open(cy_path, "w") as cy:
                    cy.write(cy_code)


if __name__ == "__main__":
    main()
