if __name__ != "test_amulet_nbt":
    raise RuntimeError(
        f"Module name is incorrect. Expected: 'test_amulet_nbt' got '{__name__}'"
    )


import faulthandler as _faulthandler

_faulthandler.enable()


def _init() -> None:
    import sys

    # Import dependencies
    import amulet.nbt

    # This needs to be an absolute path otherwise it may get called twice
    # on different module objects and crash when the interpreter shuts down.
    from test_amulet_nbt._test_amulet_nbt import init

    init(sys.modules[__name__])


_init()
