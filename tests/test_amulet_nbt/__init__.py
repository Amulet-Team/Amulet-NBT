def _init() -> None:
    import sys

    # Import dependencies
    import amulet.nbt

    # This needs to be an absolute path otherwise it may get called twice
    # on different module objects and crash when the interpreter shuts down.
    from tests.test_amulet_nbt._test_amulet_nbt import init

    init(sys.modules[__name__])


_init()
