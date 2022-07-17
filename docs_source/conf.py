# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

from typing import Tuple
import os
import sys
import subprocess
import datetime
import inspect
import importlib.machinery
import re
import amulet_nbt

ROOT = os.path.dirname(amulet_nbt.__path__[0])


# -- Project information -----------------------------------------------------

project = "Amulet NBT"
copyright = f"2018-{datetime.datetime.now().year}, The Amulet Team"
author = "The Amulet Team"


# The short X.Y version
version = ".".join(amulet_nbt.__version__.split(".")[:2])
# The full version, including alpha/beta/rc tags
release = amulet_nbt.__version__


# -- General configuration ---------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "sphinx.ext.autodoc",
    "sphinx_autodoc_typehints",
    "sphinx.ext.coverage",
    "sphinx.ext.ifconfig",
    "sphinx.ext.linkcode",
    "sphinx.ext.intersphinx",
    "sphinx.ext.graphviz",
    "sphinx.ext.inheritance_diagram",
]

commit_id = (
    subprocess.check_output(["git", "rev-parse", "HEAD"]).strip().decode("ascii")
)

# Add any paths that contain templates here, relative to this directory.
templates_path = [".templates"]

# The suffix(es) of docs_source filenames.
# You can specify multiple suffix as a list of string:
#
# source_suffix = ['.rst', '.md']
source_suffix = ".rst"

# The master toctree document.
master_doc = "index"

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = None

# List of patterns, relative to docs_source directory, that match files and
# directories to ignore when looking for docs_source files.
# This pattern also affects html_static_path and html_extra_path .
exclude_patterns = ["**/*.rst_"]

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = "sphinx"


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = "sphinx_rtd_theme"

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#
# html_theme_options = {}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = [".static"]

# Custom sidebar templates, must be a dictionary that maps document names
# to template names.
#
# The default sidebars (for documents that don't match any pattern) are
# defined by theme itself.  Builtin themes are using these templates by
# default: ``['localtoc.html', 'relations.html', 'sourcelink.html',
# 'searchbox.html']``.
#
# html_sidebars = {}


# -- Options for HTMLHelp output ---------------------------------------------

# Output file base name for HTML help builder.
htmlhelp_basename = "AmuletNBTdoc"


# -- Options for LaTeX output ------------------------------------------------

latex_elements = {
    # The paper size ('letterpaper' or 'a4paper').
    #
    # 'papersize': 'letterpaper',
    # The font size ('10pt', '11pt' or '12pt').
    #
    # 'pointsize': '10pt',
    # Additional stuff for the LaTeX preamble.
    #
    # 'preamble': '',
    # Latex figure (float) alignment
    #
    # 'figure_align': 'htbp',
}

# Grouping the document tree into LaTeX files. List of tuples
# (docs_source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (
        master_doc,
        "AmuletNBT.tex",
        "Amulet NBT Documentation",
        "The Amulet Team",
        "manual",
    )
]


# -- Options for manual page output ------------------------------------------

# One entry per manual page. List of tuples
# (docs_source start file, name, description, authors, manual section).
man_pages = [(master_doc, "amuletnbt", "Amulet NBT Documentation", [author], 1)]


# -- Options for Texinfo output ----------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (docs_source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (
        master_doc,
        "AmuletNBT",
        "Amulet NBT Documentation",
        author,
        "AmuletNBT",
        "One line description of project.",
        "Miscellaneous",
    )
]


# -- Extension configuration -------------------------------------------------
intersphinx_mapping = {
    "python": ("https://docs.python.org/3", None),
    "NumPy [latest]": ("https://numpy.org/doc/stable/", None),
}

autodoc_member_order = "bysource"

inheritance_graph_attrs = dict(rankdir="TB")
graphviz_output_format = "svg"


def skip(app, what, name, obj, would_skip, options):
    if name == "__init__":
        return False
    return would_skip


def setup(app):
    app.connect("autodoc-skip-member", skip)


def find_source(module_name: str, object_name: str) -> Tuple[str, int, int]:
    """
    Find the relative path, start line and end line of a given object.

    :param module_name: The name of module the object is contained in eg "foo.bar.baz"
    :param object_name: The name of the object to find eg Foo.__abs__
    """

    # The module location of the variable.
    module = sys.modules[module_name]

    # Keep a list of objects we have found.
    # If we can't find the location of the last object try the one before.
    objs = [module]

    # Get each object in the chain.
    obj = module
    for part in object_name.split("."):
        obj = getattr(obj, part)
        objs.append(obj)

    # Try and find the locations of the objects.
    while objs:
        obj = objs.pop()
        try:
            # try the normal inspect logic
            fn = inspect.getsourcefile(obj)
            if fn is None:
                raise Exception(f"Could not find source file for {obj}.")
            fn = os.path.relpath(
                fn, start=os.path.dirname(os.path.dirname(amulet_nbt.__file__))
            )
            source, lineno = inspect.getsourcelines(obj)
            return fn, lineno, lineno + len(source) - 1
        except:
            pass
        try:
            # Try some custom logic
            if inspect.ismodule(obj):
                path = find_code_file(obj)
                return path, 0, 0
            elif inspect.isclass(obj):
                try:
                    path = find_code_file(sys.modules[obj.__module__])
                    start = 0
                    with open(path) as f:
                        for line_index, line in enumerate(f.readlines()):
                            if re.match(f"cdef class {obj.__name__}\(", line):
                                start = line_index + 1
                                break
                    return path, start, 0
                except:
                    # if finding the class failed, try and find the module next.
                    objs.append(sys.modules[obj.__module__])
            elif hasattr(obj, "__objclass__"):
                # Is a method
                try:
                    cls = obj.__objclass__
                    path = find_code_file(sys.modules[cls.__module__])
                    start = 0
                    with open(path) as f:
                        for line_index, line in enumerate(f.readlines()):
                            if re.match(
                                f"cdef class {obj.__objclass__.__name__}\(", line
                            ):
                                start = line_index + 1
                            elif start and re.match(
                                f"(    |\t)(cdef|cpdef|def) {obj.__name__}\(", line
                            ):
                                start = line_index + 1
                                break
                    return path, start, 0
                except:
                    # if finding the method failed, try and find the class next.
                    objs.append(obj.__objclass__)
        except:
            pass


def find_code_file(module):
    """
    Given the module, tries to find the source file.
    This can be a normal python file or a compiled cython file.
    The corresponding source file with the same name must exists next to the compiled version.

    :param module: The module object to find the source file of.
    :return:
    """
    path = inspect.getsourcefile(module)
    if path is None:
        path = module.__file__
        if path.endswith(".py"):
            return os.path.relpath(path, ROOT)
        for ext in importlib.machinery.EXTENSION_SUFFIXES:
            # go through the extension suffixes and if one matches
            if path.endswith(ext):
                path_base = path[: -len(ext)]
                # Try and find the source file
                for py_ext in (".py", ".pyx"):
                    if os.path.isfile(f"{path_base}{py_ext}"):
                        return os.path.relpath(f"{path_base}{py_ext}", ROOT)
        raise Exception(f"Could not find source file for module {module}")
    return os.path.relpath(path, ROOT)


# Resolve function for the linkcode extension.
# modified from https://github.com/Lasagne/Lasagne/blob/master/docs/conf.py
def linkcode_resolve(domain, info):
    if domain != "py" or not info["module"]:
        return None
    try:
        path, start, stop = find_source(info["module"], info["fullname"])
        filename = path
        if start:
            filename += f"#L{start}"
            if stop:
                filename += f"-L{stop}"
    except Exception:
        filename = find_code_file(info["module"])
    return f"https://github.com/Amulet-Team/Amulet-NBT/blob/{commit_id}/{filename}"
