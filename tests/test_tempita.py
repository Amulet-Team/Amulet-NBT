import unittest
import os
import sys
from template import TempitaManager

ROOT_PATH = os.path.dirname(os.path.dirname(__file__))


class TestString(unittest.TestCase):
    @unittest.skipUnless(
        sys.version_info[:2] == (3, 9),
        "Different python versions produce different outputs.",
    )
    def test_is_compiled(self):
        """Check if the files have been baked out."""
        for file in TempitaManager().files:
            if file.changed:
                raise self.failureException(
                    f"Tempita file {file.rel_path} has not been compiled."
                )


if __name__ == "__main__":
    unittest.main()
