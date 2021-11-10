from typing import Iterator, Any
from io import BytesIO
from copy import deepcopy

from .value cimport BaseImmutableTag
from .const cimport ID_STRING
from .util cimport write_string, BufferContext, read_string


cdef inline escape(str string):
    return string.replace('\\', '\\\\').replace('"', '\\"')


cdef class TAG_String(BaseImmutableTag):
    """A class that behaves like a string."""
    tag_id = ID_STRING

    def __init__(TAG_String self, value = ""):
        self.value_ = str(value)

    def capitalize(self):
        """
        Return a capitalized version of the string.
        
        More specifically, make the first character have upper case and the rest lower
        case.
        """
        return self.value_.capitalize()
    
    def casefold(self):
        """Return a version of the string suitable for caseless comparisons."""
        return self.value_.casefold()
    
    def center(self, width, fillchar=' '):
        """
        Return a centered string of length width.
        
        Padding is done using the specified fill character (default is a space).
        """
        return self.value_.center(width, fillchar)
    
    def encode(self, encoding='utf-8', errors='strict'):
        """
        Encode the string using the codec registered for encoding.
        
        encoding
          The encoding in which to encode the string.
        errors
          The error handling scheme to use for encoding errors.
          The default is 'strict' meaning that encoding errors raise a
          UnicodeEncodeError.  Other possible values are 'ignore', 'replace' and
          'xmlcharrefreplace' as well as any other name registered with
          codecs.register_error that can handle UnicodeEncodeErrors.
        """
        return self.value_.encode(encoding, errors)
    
    def expandtabs(self, tabsize=8):
        """
        Return a copy where all tab characters are expanded using spaces.
        
        If tabsize is not given, a tab size of 8 characters is assumed.
        """
        return self.value_.expandtabs(tabsize)
    
    def isalnum(self):
        """
        Return True if the string is an alpha-numeric string, False otherwise.
        
        A string is alpha-numeric if all characters in the string are alpha-numeric and
        there is at least one character in the string.
        """
        return self.value_.isalnum()
    
    def isalpha(self):
        """
        Return True if the string is an alphabetic string, False otherwise.
        
        A string is alphabetic if all characters in the string are alphabetic and there
        is at least one character in the string.
        """
        return self.value_.isalpha()
    
    def isascii(self):
        """
        Return True if all characters in the string are ASCII, False otherwise.
        
        ASCII characters have code points in the range U+0000-U+007F.
        Empty string is ASCII too.
        """
        return self.value_.isascii()
    
    def isdecimal(self):
        """
        Return True if the string is a decimal string, False otherwise.
        
        A string is a decimal string if all characters in the string are decimal and
        there is at least one character in the string.
        """
        return self.value_.isdecimal()
    
    def isdigit(self):
        """
        Return True if the string is a digit string, False otherwise.
        
        A string is a digit string if all characters in the string are digits and there
        is at least one character in the string.
        """
        return self.value_.isdigit()
    
    def isidentifier(self):
        """
        Return True if the string is a valid Python identifier, False otherwise.
        
        Call keyword.iskeyword(s) to test whether string s is a reserved identifier,
        such as "def" or "class".
        """
        return self.value_.isidentifier()
    
    def islower(self):
        """
        Return True if the string is a lowercase string, False otherwise.
        
        A string is lowercase if all cased characters in the string are lowercase and
        there is at least one cased character in the string.
        """
        return self.value_.islower()
    
    def isnumeric(self):
        """
        Return True if the string is a numeric string, False otherwise.
        
        A string is numeric if all characters in the string are numeric and there is at
        least one character in the string.
        """
        return self.value_.isnumeric()
    
    def isprintable(self):
        """
        Return True if the string is printable, False otherwise.
        
        A string is printable if all of its characters are considered printable in
        repr() or if it is empty.
        """
        return self.value_.isprintable()
    
    def isspace(self):
        """
        Return True if the string is a whitespace string, False otherwise.
        
        A string is whitespace if all characters in the string are whitespace and there
        is at least one character in the string.
        """
        return self.value_.isspace()
    
    def istitle(self):
        """
        Return True if the string is a title-cased string, False otherwise.
        
        In a title-cased string, upper- and title-case characters may only
        follow uncased characters and lowercase characters only cased ones.
        """
        return self.value_.istitle()
    
    def isupper(self):
        """
        Return True if the string is an uppercase string, False otherwise.
        
        A string is uppercase if all cased characters in the string are uppercase and
        there is at least one cased character in the string.
        """
        return self.value_.isupper()
    
    def join(self, iterable):
        """
        Concatenate any number of strings.
        
        The string whose method is called is inserted in between each given string.
        The result is returned as a new string.
        
        Example: '.'.join(['ab', 'pq', 'rs']) -> 'ab.pq.rs'
        """
        return self.value_.join(iterable)
    
    def ljust(self, width, fillchar=' '):
        """
        Return a left-justified string of length width.
        
        Padding is done using the specified fill character (default is a space).
        """
        return self.value_.ljust(width, fillchar)
    
    def lower(self):
        """Return a copy of the string converted to lowercase."""
        return self.value_.lower()
    
    def lstrip(self, chars=None):
        """
        Return a copy of the string with leading whitespace removed.
        
        If chars is given and not None, remove characters in chars instead.
        """
        return self.value_.lstrip(chars)
    
    def partition(self, sep):
        """
        Partition the string into three parts using the given separator.
        
        This will search for the separator in the string.  If the separator is found,
        returns a 3-tuple containing the part before the separator, the separator
        itself, and the part after it.
        
        If the separator is not found, returns a 3-tuple containing the original string
        and two empty strings.
        """
        return self.value_.partition(sep)
    
    def removeprefix(self, prefix):
        """
        Return a str with the given prefix string removed if present.
        
        If the string starts with the prefix string, return string[len(prefix):].
        Otherwise, return a copy of the original string.
        """
        return self.value_.removeprefix(prefix)
    
    def removesuffix(self, suffix):
        """
        Return a str with the given suffix string removed if present.
        
        If the string ends with the suffix string and that suffix is not empty,
        return string[:-len(suffix)]. Otherwise, return a copy of the original
        string.
        """
        return self.value_.removesuffix(suffix)
    
    def replace(self, old, new, count=-1):
        """
        Return a copy with all occurrences of substring old replaced by new.
        
          count
            Maximum number of occurrences to replace.
            -1 (the default value) means replace all occurrences.
        
        If the optional argument count is given, only the first count occurrences are
        replaced.
        """
        return self.value_.replace(old, new, count)
    
    def rjust(self, width, fillchar=' '):
        """
        Return a right-justified string of length width.
        
        Padding is done using the specified fill character (default is a space).
        """
        return self.value_.rjust(width, fillchar)
    
    def rpartition(self, sep):
        """
        Partition the string into three parts using the given separator.
        
        This will search for the separator in the string, starting at the end. If
        the separator is found, returns a 3-tuple containing the part before the
        separator, the separator itself, and the part after it.
        
        If the separator is not found, returns a 3-tuple containing two empty strings
        and the original string.
        """
        return self.value_.rpartition(sep)
    
    def rsplit(self, sep=None, maxsplit=-1):
        """
        Return a list of the words in the string, using sep as the delimiter string.
        
          sep
            The delimiter according which to split the string.
            None (the default value) means split according to any whitespace,
            and discard empty strings from the result.
          maxsplit
            Maximum number of splits to do.
            -1 (the default value) means no limit.
        
        Splits are done starting at the end of the string and working to the front.
        """
        return self.value_.rsplit(sep, maxsplit)
    
    def rstrip(self, chars=None):
        """
        Return a copy of the string with trailing whitespace removed.
        
        If chars is given and not None, remove characters in chars instead.
        """
        return self.value_.rstrip(chars)
    
    def split(self, sep=None, maxsplit=-1):
        """
        Return a list of the words in the string, using sep as the delimiter string.
        
        sep
          The delimiter according which to split the string.
          None (the default value) means split according to any whitespace,
          and discard empty strings from the result.
        maxsplit
          Maximum number of splits to do.
          -1 (the default value) means no limit.
        """
        return self.value_.split(sep, maxsplit)
    
    def splitlines(self, keepends=False):
        """
        Return a list of the lines in the string, breaking at line boundaries.
        
        Line breaks are not included in the resulting list unless keepends is given and
        true.
        """
        return self.value_.splitlines(keepends)
    
    def strip(self, chars=None):
        """
        Return a copy of the string with leading and trailing whitespace removed.
        
        If chars is given and not None, remove characters in chars instead.
        """
        return self.value_.strip(chars)
    
    def swapcase(self):
        """Convert uppercase characters to lowercase and lowercase characters to uppercase."""
        return self.value_.swapcase()
    
    def title(self):
        """
        Return a version of the string where each word is titlecased.
        
        More specifically, words start with uppercased characters and all remaining
        cased characters have lower case.
        """
        return self.value_.title()
    
    def translate(self, table):
        """
        Replace each character in the string using the given translation table.
        
          table
            Translation table, which must be a mapping of Unicode ordinals to
            Unicode ordinals, strings, or None.
        
        The table must implement lookup/indexing via __getitem__, for instance a
        dictionary or list.  If this operation raises LookupError, the character is
        left untouched.  Characters mapped to None are deleted.
        """
        return self.value_.translate(table)
    
    def upper(self):
        """Return a copy of the string converted to uppercase."""
        return self.value_.upper()
    
    def zfill(self, width):
        """
        Pad a numeric string with zeros on the left, to fill a field of the given width.
        
        The string is never truncated.
        """
        return self.value_.zfill(width)
    
    def count(self, *args, **kwargs):
        """
        S.count(sub[, start[, end]]) -> int
        
        Return the number of non-overlapping occurrences of substring sub in
        string S[start:end].  Optional arguments start and end are
        interpreted as in slice notation.
        """
        return self.value_.count(*args, **kwargs)
    
    def endswith(self, *args, **kwargs):
        """
        S.endswith(suffix[, start[, end]]) -> bool
        
        Return True if S ends with the specified suffix, False otherwise.
        With optional start, test S beginning at that position.
        With optional end, stop comparing S at that position.
        suffix can also be a tuple of strings to try.
        """
        return self.value_.endswith(*args, **kwargs)
    
    def find(self, *args, **kwargs):
        """
        S.find(sub[, start[, end]]) -> int
        
        Return the lowest index in S where substring sub is found,
        such that sub is contained within S[start:end].  Optional
        arguments start and end are interpreted as in slice notation.
        
        Return -1 on failure.
        """
        return self.value_.find(*args, **kwargs)
    
    def format(self, *args, **kwargs):
        """
        S.format(*args, **kwargs) -> str
        
        Return a formatted version of S, using substitutions from args and kwargs.
        The substitutions are identified by braces ('{' and '}').
        """
        return self.value_.format(*args, **kwargs)
    
    def format_map(self, *args, **kwargs):
        """
        S.format_map(mapping) -> str
        
        Return a formatted version of S, using substitutions from mapping.
        The substitutions are identified by braces ('{' and '}').
        """
        return self.value_.format_map(*args, **kwargs)
    
    def index(self, *args, **kwargs):
        """
        S.index(sub[, start[, end]]) -> int
        
        Return the lowest index in S where substring sub is found,
        such that sub is contained within S[start:end].  Optional
        arguments start and end are interpreted as in slice notation.
        
        Raises ValueError when the substring is not found.
        """
        return self.value_.index(*args, **kwargs)
    
    def rfind(self, *args, **kwargs):
        """
        S.rfind(sub[, start[, end]]) -> int
        
        Return the highest index in S where substring sub is found,
        such that sub is contained within S[start:end].  Optional
        arguments start and end are interpreted as in slice notation.
        
        Return -1 on failure.
        """
        return self.value_.rfind(*args, **kwargs)
    
    def rindex(self, *args, **kwargs):
        """
        S.rindex(sub[, start[, end]]) -> int
        
        Return the highest index in S where substring sub is found,
        such that sub is contained within S[start:end].  Optional
        arguments start and end are interpreted as in slice notation.
        
        Raises ValueError when the substring is not found.
        """
        return self.value_.rindex(*args, **kwargs)
    
    def startswith(self, *args, **kwargs):
        """
        S.startswith(prefix[, start[, end]]) -> bool
        
        Return True if S starts with the specified prefix, False otherwise.
        With optional start, test S beginning at that position.
        With optional end, stop comparing S at that position.
        prefix can also be a tuple of strings to try.
        """
        return self.value_.startswith(*args, **kwargs)
    
    def __str__(TAG_String self):
        return str(self.value_)

    def __dir__(TAG_String self):
        return list(set(list(super().__dir__()) + dir(self.value_)))

    def __eq__(TAG_String self, other):
        return self.value_ == other

    def __ge__(TAG_String self, other):
        return self.value_ >= other

    def __gt__(TAG_String self, other):
        return self.value_ > other

    def __le__(TAG_String self, other):
        return self.value_ <= other

    def __lt__(TAG_String self, other):
        return self.value_ < other

    def __reduce__(TAG_String self):
        return self.__class__, (self.value_,)

    def __deepcopy__(TAG_String self, memo=None):
        return self.__class__(deepcopy(self.value_, memo=memo))

    def __copy__(TAG_String self):
        return self.__class__(self.value_)

    def __hash__(TAG_String self):
        return hash((self.tag_id, self.value_))

    @property
    def value(TAG_String self):
        """
        A copy of the data stored in the class.
        Use the public API to modify the data within the class.
        """
        return self.value_

    def __len__(TAG_String self) -> int:
        return len(self.value_)

    def __repr__(TAG_String self):
        return f"{self.__class__.__name__}(\"{self.value_}\")"

    cdef str _to_snbt(TAG_String self):
        return f"\"{escape(self.value_)}\""

    cdef void write_payload(TAG_String self, object buffer: BytesIO, bint little_endian) except *:
        write_string(self.value_, buffer, little_endian)

    @staticmethod
    cdef TAG_String read_payload(BufferContext buffer, bint little_endian):
        cdef TAG_String tag = TAG_String.__new__(TAG_String)
        tag.value_ = read_string(buffer, little_endian)
        return tag

    def __getitem__(TAG_String self, item):
        return self.value_.__getitem__(item)

    def __add__(TAG_String self, other):
        return self.value_ + other

    def __radd__(TAG_String self, other):
        return other + self.value_

    def __iadd__(TAG_String self, other):
        res = self + other
        if isinstance(res, str):
            return self.__class__(res)
        return res

    def __mul__(TAG_String self, other):
        return self.value_ * other

    def __rmul__(TAG_String self, other):
        return other * self.value_

    def __imul__(TAG_String self, other):
        res = self * other
        if isinstance(res, str):
            return self.__class__(res)
        return res

    def __contains__(self, o: str) -> bool:
        return o in self.value_

    def __iter__(self) -> Iterator[str]:
        return self.value_.__iter__()

    def __mod__(self, x: Any) -> str:
        return self.value_ % x
