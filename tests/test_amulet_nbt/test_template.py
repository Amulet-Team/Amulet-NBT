import unittest
from template import TempitaManager


class TestString(unittest.TestCase):
    def test_is_compiled(self) -> None:
        """Check if the files have been baked out."""
        for file in TempitaManager().files:
            if file.changed:
                raise self.failureException(
                    f"Tempita file {file.rel_path} has not been compiled."
                )


if __name__ == "__main__":
    unittest.main()
