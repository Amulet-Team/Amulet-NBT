import unittest
import glob
import os
import difflib
import sys
from Cython import Tempita as tempita

ROOT_PATH = os.path.dirname(os.path.dirname(__file__))


class TestString(unittest.TestCase):
    @unittest.skipUnless(
        sys.version_info[:2] == (3, 9),
        "Different python versions produce different outputs.",
    )
    def test_is_compiled(self):
        """Check if the files have been baked out."""
        for path in glob.glob(
            os.path.join(ROOT_PATH, "amulet_nbt", "**", "*.pyx.in"), recursive=True
        ):
            if os.path.basename(path).islower():
                with open(path) as template:
                    cy_code = tempita.sub(template.read())
                cy_path = path[:-3]

                with open(cy_path) as cy:
                    file_source = cy.read()
                    if file_source != cy_code:
                        for line in difflib.unified_diff(
                            file_source.splitlines(), cy_code.splitlines()
                        ):
                            print(line)
                    self.assertTrue(
                        file_source == cy_code,
                        msg=f"Tempita file {path} has not been compiled.",
                    )


if __name__ == "__main__":
    unittest.main()
