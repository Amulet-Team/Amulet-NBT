import sys

from template.tempita import TempitaManager


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "check":
        TempitaManager().check()
    else:
        TempitaManager().build()


if __name__ == "__main__":
    main()
